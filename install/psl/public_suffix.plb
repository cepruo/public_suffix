prompt creating public_suffix body
create or replace package body public_suffix as

  type t_label_coll is table of string(4000);

  --

  procedure loading_function (p_file_location in string) 
    is
  begin
    delete public_suffix_dat d;
    --
    execute immediate 
    'insert into public_suffix_dat 
    select t.rule from psl_dat_ext  
    external modify
    ( 
    location (:p_file_location)) t
    where t.rule is not null 
    and substr(t.rule, 1,2)<>''//''' using p_file_location;
    commit;
  end loading_function;

  --
  
  function parse_labels(p_host in string) return t_label_coll
    is
      l_label_coll t_label_coll;
  begin
      select tab.lbl 
        bulk collect into l_label_coll 
      from (select level as lvl
                  ,regexp_substr(p_host,'[^\.]+', 1, level) as  lbl 
              from dual
            connect by regexp_substr(p_host, '[^\.]+', 1, level) is not null) tab 
      order by tab.lvl desc;
      --
      return l_label_coll;
  end parse_labels;
  
  --
  
  function get_psl_rule(p_host in string) return string
    is
    l_rule string(4000);
  begin
      select tab.rule 
            into l_rule
            from (select d.rule as rule
                       , row_number() over (order by regexp_count(replace(replace(d.rule, '!', '..'), '*', '.'), '\.') desc) as rn 
                    from (select sf.rule from public_suffix_dat sf
                           --where p_host like replace(replace(replace('%'||sf.rule,'*', '%'), '%%', '%'), '%!', '%')) d) tab 
                           where '.'||p_host like '%.'||replace(replace(sf.rule, '*', '%'),'!', ''))  d) tab 
           where tab.rn=1;
           return l_rule;
  exception
          when no_data_found then
              return '*'; -- according to step 2 algorithm https://publicsuffix.org/list/
  end get_psl_rule;
  
  --
  
  function get_registrable_domain(p_host in string) return string
    is
    l_host string(4000):=lower(p_host);
    l_rule        public_suffix_dat.rule%type;
    l_rule_labels t_label_coll;
    l_host_labels t_label_coll;
    l_reg_domain  string(4000);
  begin
    --
     if substr(p_host, 1, 1)='.' then return ''; end if;

     l_rule:=get_psl_rule(l_host);     
     --
     l_rule_labels:=parse_labels(l_rule);
     l_host_labels:=parse_labels(l_host);
     if l_host_labels.count=1 then return ''; end if;
     --
     for i in reverse l_rule_labels.first..l_rule_labels.last
         loop
             if l_rule_labels(i) <> '*' then
                 l_reg_domain:=l_reg_domain||l_rule_labels(i);
             else
                 l_reg_domain:=l_reg_domain||l_host_labels(i);
             end if;
             --
             if l_rule_labels.exists(l_rule_labels.prior(i)) then
                 l_reg_domain:=l_reg_domain||'.';
             end if;
         end loop;
     --
     if substr(l_reg_domain, 1,1)='!' then
         l_reg_domain:=replace(l_reg_domain, '!', '');
     else
         if l_host_labels.exists(l_rule_labels.count+1) then
             l_reg_domain:=l_host_labels(l_rule_labels.count+1)||'.'||l_reg_domain;
         else 
             l_reg_domain:='';
         end if;
     end if;
     --
     return l_reg_domain;
  end get_registrable_domain;
  
  --

  function check_public_suffix (p_input in string, p_assert_output in string) return string 
    is
    l_registrable_domain string(4000);
    -- https://bugzilla.mozilla.org/show_bug.cgi?id=779845
    l_ret string(4000);
    l_test_run constant varchar2(4000):= 'check_public_suffix('''||nvl(p_input, 'NULL')||''', '''||nvl(p_assert_output, 'NULL')||''') = ';
  begin
      l_registrable_domain := get_registrable_domain(p_input);
      if (p_assert_output is null and l_registrable_domain is null) or l_registrable_domain=p_assert_output then
         l_ret:='PASSED '||l_test_run||'TRUE';
      else 
         l_ret:='FAILED '||l_test_run||'FALSE; l_registrable_domain = '''||nvl(l_registrable_domain, 'NULL')||'''';
      end if;
      --
      return l_ret;
  end check_public_suffix;

  --
  
  function extract_host(p_url in string) return string
    is
    lc_ignore_case constant char(1)     := 'i';
    lc_is_email     constant string(255) := '^[a-zA-Z0-9_\.\-]+@[a-zA-Z0-9_\.\-]+$';
    -- URI = scheme:[//authority]path[?query][#fragment]
    -- authority = [userinfo@]host[:port]
    l_host string(4000);
  begin
      --
      if regexp_count(p_url, '[@\/:]')=0 then
          l_host:=p_url;
      elsif regexp_count(p_url, '[\/:]')=0 and regexp_like(p_url, lc_is_email) then
          l_host := substr(p_url, instr(p_url, '@')+1);
      else 
          l_host:=regexp_substr(p_url, '^\w+?:\/{1,2}(.+)\/{1,}.*', 1,1,lc_ignore_case, 1);
          --
          if instr(l_host, '@')>0 then
              l_host:=substr(l_host, instr(l_host, '@')+1);
          end if;
          --
          if instr(l_host, ':')>0 then
              l_host:=substr(l_host, 1, instr(l_host, ':')-1);
          end if;
          --
          end if;
      return l_host;
  end extract_host;
  
  --

  function extract_domain (p_input in string) return string 
    is
      l_host        string(4000);
      l_apex_domain string(4000);
  begin
      if p_input is null then
          null;
      else
          l_host := extract_host(lower(p_input));
          l_apex_domain:= get_registrable_domain(l_host);
      end if;
      return l_apex_domain;
  end extract_domain;

end public_suffix;
