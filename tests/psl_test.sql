begin
dbms_output.put_line(' Any copyright is dedicated to the Public Domain.');
dbms_output.put_line(' https://creativecommons.org/publicdomain/zero/1.0/');
dbms_output.put_line('----------------------------------------------------------------------');
--
dbms_output.put_line(' null input.');
dbms_output.put_line(public_suffix.check_public_suffix(null, null));
--
dbms_output.put_line(' Mixed case.');
dbms_output.put_line(public_suffix.check_public_suffix('COM', null));
dbms_output.put_line(public_suffix.check_public_suffix('example.COM', 'example.com'));
dbms_output.put_line(public_suffix.check_public_suffix('WwW.example.COM', 'example.com'));
--
dbms_output.put_line(' Leading dot. ');
dbms_output.put_line(public_suffix.check_public_suffix('.com', null));
dbms_output.put_line(public_suffix.check_public_suffix('.example', null));
dbms_output.put_line(public_suffix.check_public_suffix('.example.com', null));
dbms_output.put_line(public_suffix.check_public_suffix('.example.example', null));
--
dbms_output.put_line(' Unlisted TLD.');
dbms_output.put_line(public_suffix.check_public_suffix('example', null));
dbms_output.put_line(public_suffix.check_public_suffix('example.example', 'example.example'));
dbms_output.put_line(public_suffix.check_public_suffix('b.example.example', 'example.example'));
dbms_output.put_line(public_suffix.check_public_suffix('a.b.example.example', 'example.example'));
--
--Listed, but non-Internet, TLD.
--public_suffix.check_public_suffix('local', null);
--public_suffix.check_public_suffix('example.local', null);
--public_suffix.check_public_suffix('b.example.local', null);
--public_suffix.check_public_suffix('a.b.example.local', null);
--
dbms_output.put_line(' TLD with only 1 rule.');
dbms_output.put_line(public_suffix.check_public_suffix('biz', null));
dbms_output.put_line(public_suffix.check_public_suffix('domain.biz', 'domain.biz'));
dbms_output.put_line(public_suffix.check_public_suffix('b.domain.biz', 'domain.biz'));
dbms_output.put_line(public_suffix.check_public_suffix('a.b.domain.biz', 'domain.biz'));
--
dbms_output.put_line(' TLD with some 2-level rules.');
dbms_output.put_line(public_suffix.check_public_suffix('com', null));
dbms_output.put_line(public_suffix.check_public_suffix('example.com', 'example.com'));
dbms_output.put_line(public_suffix.check_public_suffix('b.example.com', 'example.com'));
dbms_output.put_line(public_suffix.check_public_suffix('a.b.example.com', 'example.com'));
dbms_output.put_line(public_suffix.check_public_suffix('uk.com', null));
dbms_output.put_line(public_suffix.check_public_suffix('example.uk.com', 'example.uk.com'));
dbms_output.put_line(public_suffix.check_public_suffix('b.example.uk.com', 'example.uk.com'));
dbms_output.put_line(public_suffix.check_public_suffix('a.b.example.uk.com', 'example.uk.com'));
dbms_output.put_line(public_suffix.check_public_suffix('test.ac', 'test.ac'));
--
dbms_output.put_line(' TLD with only 1 (wildcard) rule.');
dbms_output.put_line(public_suffix.check_public_suffix('mm', null));
dbms_output.put_line(public_suffix.check_public_suffix('c.mm', null));
dbms_output.put_line(public_suffix.check_public_suffix('b.c.mm', 'b.c.mm'));
dbms_output.put_line(public_suffix.check_public_suffix('a.b.c.mm', 'b.c.mm'));
--
dbms_output.put_line(' More complex TLD.');
dbms_output.put_line(public_suffix.check_public_suffix('jp', null));
dbms_output.put_line(public_suffix.check_public_suffix('test.jp', 'test.jp'));
dbms_output.put_line(public_suffix.check_public_suffix('www.test.jp', 'test.jp'));
dbms_output.put_line(public_suffix.check_public_suffix('ac.jp', null));
dbms_output.put_line(public_suffix.check_public_suffix('test.ac.jp', 'test.ac.jp'));
dbms_output.put_line(public_suffix.check_public_suffix('www.test.ac.jp', 'test.ac.jp'));
dbms_output.put_line(public_suffix.check_public_suffix('kyoto.jp', null));
dbms_output.put_line(public_suffix.check_public_suffix('test.kyoto.jp', 'test.kyoto.jp'));
dbms_output.put_line(public_suffix.check_public_suffix('ide.kyoto.jp', null));
dbms_output.put_line(public_suffix.check_public_suffix('b.ide.kyoto.jp', 'b.ide.kyoto.jp'));
dbms_output.put_line(public_suffix.check_public_suffix('a.b.ide.kyoto.jp', 'b.ide.kyoto.jp'));
dbms_output.put_line(public_suffix.check_public_suffix('c.kobe.jp', null));
dbms_output.put_line(public_suffix.check_public_suffix('b.c.kobe.jp', 'b.c.kobe.jp'));
dbms_output.put_line(public_suffix.check_public_suffix('a.b.c.kobe.jp', 'b.c.kobe.jp'));
dbms_output.put_line(public_suffix.check_public_suffix('city.kobe.jp', 'city.kobe.jp'));
dbms_output.put_line(public_suffix.check_public_suffix('www.city.kobe.jp', 'city.kobe.jp'));
--
dbms_output.put_line(' TLD with a wildcard rule and exceptions.');
dbms_output.put_line(public_suffix.check_public_suffix('ck', null));
dbms_output.put_line(public_suffix.check_public_suffix('test.ck', null));
dbms_output.put_line(public_suffix.check_public_suffix('b.test.ck', 'b.test.ck'));
dbms_output.put_line(public_suffix.check_public_suffix('a.b.test.ck', 'b.test.ck'));
dbms_output.put_line(public_suffix.check_public_suffix('www.ck', 'www.ck'));
dbms_output.put_line(public_suffix.check_public_suffix('www.www.ck', 'www.ck'));
--
dbms_output.put_line(' US K12.');
dbms_output.put_line(public_suffix.check_public_suffix('us', null));
dbms_output.put_line(public_suffix.check_public_suffix('test.us', 'test.us'));
dbms_output.put_line(public_suffix.check_public_suffix('www.test.us', 'test.us'));
dbms_output.put_line(public_suffix.check_public_suffix('ak.us', null));
dbms_output.put_line(public_suffix.check_public_suffix('test.ak.us', 'test.ak.us'));
dbms_output.put_line(public_suffix.check_public_suffix('www.test.ak.us', 'test.ak.us'));
dbms_output.put_line(public_suffix.check_public_suffix('k12.ak.us', null));
dbms_output.put_line(public_suffix.check_public_suffix('test.k12.ak.us', 'test.k12.ak.us'));
dbms_output.put_line(public_suffix.check_public_suffix('www.test.k12.ak.us', 'test.k12.ak.us'));
--
dbms_output.put_line(' IDN labels.');
dbms_output.put_line(public_suffix.check_public_suffix('食狮.com.cn', '食狮.com.cn'));
dbms_output.put_line(public_suffix.check_public_suffix('食狮.公司.cn', '食狮.公司.cn'));
dbms_output.put_line(public_suffix.check_public_suffix('www.食狮.公司.cn', '食狮.公司.cn'));
dbms_output.put_line(public_suffix.check_public_suffix('shishi.公司.cn', 'shishi.公司.cn'));
dbms_output.put_line(public_suffix.check_public_suffix('公司.cn', null));
dbms_output.put_line(public_suffix.check_public_suffix('食狮.中国', '食狮.中国'));
dbms_output.put_line(public_suffix.check_public_suffix('www.食狮.中国', '食狮.中国'));
dbms_output.put_line(public_suffix.check_public_suffix('shishi.中国', 'shishi.中国'));
dbms_output.put_line(public_suffix.check_public_suffix('中国', null));
--
dbms_output.put_line(' Same as above, but punycoded. Commented');
--public_suffix.check_public_suffix('xn--85x722f.com.cn', 'xn--85x722f.com.cn');
--public_suffix.check_public_suffix('xn--85x722f.xn--55qx5d.cn', 'xn--85x722f.xn--55qx5d.cn');
--public_suffix.check_public_suffix('www.xn--85x722f.xn--55qx5d.cn', 'xn--85x722f.xn--55qx5d.cn');
--public_suffix.check_public_suffix('shishi.xn--55qx5d.cn', 'shishi.xn--55qx5d.cn');
--public_suffix.check_public_suffix('xn--55qx5d.cn', null);
--public_suffix.check_public_suffix('xn--85x722f.xn--fiqs8s', 'xn--85x722f.xn--fiqs8s');
--public_suffix.check_public_suffix('www.xn--85x722f.xn--fiqs8s', 'xn--85x722f.xn--fiqs8s');
--public_suffix.check_public_suffix('shishi.xn--fiqs8s', 'shishi.xn--fiqs8s');
--public_suffix.check_public_suffix('xn--fiqs8s', null);
end;

