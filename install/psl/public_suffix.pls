prompt creating public_suffix spec
create or replace package public_suffix as
  -- sys.standard declaration subtype string is varchar2
    --

    procedure loading_function (p_file_location in string);

    --

    function check_public_suffix (p_input in string, p_assert_output in string) return string;

    --

    function extract_domain (p_input in string) return string;
  
  
end public_suffix;
