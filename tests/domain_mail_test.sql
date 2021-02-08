begin
if public_suffix.extract_domain('www.google.com')='google.com' then 
dbms_output.put_line('PASSED www.google.com - > google.com');
else
dbms_output.put_line('FAILED www.google.com - > google.com');
end if;
--
if public_suffix.extract_domain('test@yahoo.com')='yahoo.com' then 
dbms_output.put_line('PASSED test@yahoo.com -> yahoo.com');
else
dbms_output.put_line('FAILED test@yahoo.com -> yahoo.com');
end if;
--
if public_suffix.extract_domain('https://foo.bar.baz.kyoto.jp/index.jsp?foo=bar')='baz.kyoto.jp' then 
dbms_output.put_line('PASSED https://foo.bar.baz.kyoto.jp/index.jsp?foo=bar -> baz.kyoto.jp');
else
dbms_output.put_line('FAILED https://foo.bar.baz.kyoto.jp/index.jsp?foo=bar -> baz.kyoto.jp');
end if;
--
if public_suffix.extract_domain('https://user:password@鹿児.鹿児島.jp/')='鹿児.鹿児島.jp' then 
dbms_output.put_line('PASSED https://user:password@鹿児.鹿児島.jp/ -> 鹿児.鹿児島.jp');
else
dbms_output.put_line('FAILED https://user:password@鹿児.鹿児島.jp/ -> 鹿児.鹿児島.jp');
end if;
if public_suffix.extract_domain('ax.city.kitakyushu.jp')='city.kitakyushu.jp' then 
dbms_output.put_line('PASSED ax.city.kitakyushu.jp -> city.kitakyushu.jp');
else
dbms_output.put_line('FAILED ax.city.kitakyushu.jp -> city.kitakyushu.jp');
end if;
--
if public_suffix.extract_domain('foo.bar') is null then 
dbms_output.put_line('PASSED foo.bar - > NULL');
else
dbms_output.put_line('FAILED foo.bar - > NULL');
end if;

end;
