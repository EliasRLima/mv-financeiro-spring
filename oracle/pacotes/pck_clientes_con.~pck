create or replace package apl_financeira.pck_clientes_con is

  -- Author  : elias
  -- Purpose : lista de clientes

  procedure executa(p_nome          in varchar2,
                    p_cpfcnpj       in varchar2,
                    p_lista_retorno out apl_financeira.pck_tipos.t_cursor,
                    p_erro          out varchar2,
                    p_msg_retorno   out varchar2);

end;
/
create or replace package body apl_financeira.pck_clientes_con is

  procedure executa(p_nome          in varchar2,
                    p_cpfcnpj       in varchar2,
                    p_lista_retorno out apl_financeira.pck_tipos.t_cursor,
                    p_erro          out varchar2,
                    p_msg_retorno   out varchar2) is
    v_sql varchar2(2000);
  begin
  
    v_sql := 'select c.idcliente,
                        c.nome,
                        c.cpfcnpj,
                        c.tipocliente,
                        c.telefone 
                   from apl_financeira.tab_cliente c';
  
    if p_cpfcnpj is not null then
      if lower(v_sql) not like '%where%' then
        v_sql := v_sql || ' where c.cpfcnpj = ''' || p_cpfcnpj || '''';
      else
        v_sql := v_sql || ' and c.cpfcnpj = ''' || p_cpfcnpj || '''';
      end if;
    end if;
  
    if p_nome is not null then
      if lower(v_sql) not like '%where%' then
        v_sql := v_sql || ' where lower(c.cpfcnpj) like ''%' ||
                 lower(p_cpfcnpj) || '%''';
      else
        v_sql := v_sql || ' and c.cpfcnpj like ''%' || lower(p_cpfcnpj) ||
                 '%''';
      end if;
    end if;
  
    open p_lista_retorno for v_sql;
    p_erro        := 'N';
    p_msg_retorno := 'Busca clientes efetuada.';
  
  exception
    when others then
      open p_lista_retorno for
        select 0 from dual;
      p_erro        := 'S';
      p_msg_retorno := 'Falha ao buscar clientes.';
    
  end;

end;
/
