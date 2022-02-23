create or replace package apl_financeira.pck_relatorio_cliente is

  -- Author  : elias

  procedure executa(p_cpfcnpj       in varchar2,
                    p_dt_ini        in date,
                    p_dt_fim        in date,
                    p_lista_retorno out apl_financeira.pck_tipos.t_cursor,
                    p_erro          out varchar2,
                    p_msg_retorno   out varchar2);

end;
/
create or replace package body apl_financeira.pck_relatorio_cliente is

  procedure executa(p_cpfcnpj       in varchar2,
                    p_dt_ini        in date,
                    p_dt_fim        in date,
                    p_lista_retorno out apl_financeira.pck_tipos.t_cursor,
                    p_erro          out varchar2,
                    p_msg_retorno   out varchar2) is
  
    v_count_cred number;
    v_count_deb  number;
    v_comissao_cred number;
    v_comissao_deb number;
  
    v_idcliente      number;
    v_dt_ini_cliente date;
    
    v_saldo number;
    v_saldo_inicial number;
    v_saldo_total number;
  
  begin
  
    if p_cpfcnpj is not null then
      begin
        select c.idcliente
          into v_idcliente
          from apl_financeira.tab_cliente c
         where c.cpfcnpj = p_cpfcnpj;
      exception
        when NO_DATA_FOUND then
          open p_lista_retorno for
            select 0 from dual;
          p_erro        := 'S';
          p_msg_retorno := 'Cliente nao localizado.';
          return;
        when others then
          open p_lista_retorno for
            select 0 from dual;
          p_erro        := 'S';
          p_msg_retorno := 'Falha ao buscar cliente.';
          return;
      end;
    else
      open p_lista_retorno for
        select 0 from dual;
      p_erro        := 'S';
      p_msg_retorno := 'CPF/CNPJ do cliente nao informado.';
      return;
    end if;
  
    begin
      select min(t.data) into v_dt_ini_cliente
        from apl_financeira.tab_transacao t, apl_financeira.tab_conta c
       where t.idconta = c.idconta
         and c.idcliente = v_idcliente;
         
      select t.valor into v_saldo_inicial
        from apl_financeira.tab_transacao t, apl_financeira.tab_conta c
       where t.idconta = c.idconta
       and t.data = v_dt_ini_cliente
       and c.idcliente = v_idcliente;
       
      select sum(c.saldo) into v_saldo_total
      from apl_financeira.tab_conta c
      where c.idcliente = v_idcliente;
       
    exception
      when others then
        open p_lista_retorno for select 0 from dual;
        p_erro        := 'S';
        p_msg_retorno := 'Falha ao buscar a data do cadastro do cliente.';
        return;
    end;
  
    if p_dt_ini is not null then
      --nao limita por periodo
      select count(0) into v_count_deb
        from apl_financeira.tab_transacao t, apl_financeira.tab_conta c
       where t.idconta = c.idconta
         and t.tipotransacao = 1 --transacao de debito
         and c.idcliente = v_idcliente;
         
      select sum(t.comissao) into v_comissao_deb
        from apl_financeira.tab_transacao t, apl_financeira.tab_conta c
       where t.idconta = c.idconta
         and t.tipotransacao = 1 --transacao de debito
         and c.idcliente = v_idcliente;
    
      select count(0) into v_count_cred
        from apl_financeira.tab_transacao t, apl_financeira.tab_conta c
       where t.idconta = c.idconta
         and t.tipotransacao = 2 --transacao de credito
         and c.idcliente = v_idcliente;
      
      select sum(t.comissao) into v_comissao_cred
        from apl_financeira.tab_transacao t, apl_financeira.tab_conta c
       where t.idconta = c.idconta
         and t.tipotransacao = 2 --transacao de credito
         and c.idcliente = v_idcliente;
    else
      --limitando por periodo
      select count(0) into v_count_deb
        from apl_financeira.tab_transacao t, apl_financeira.tab_conta c
       where t.idconta = c.idconta
         and t.tipotransacao = 1 --transacao de debito
         and t.data between p_dt_ini and nvl(p_dt_fim, sysdate)
         and c.idcliente = v_idcliente;
         
      select sum(t.comissao) into v_comissao_deb
        from apl_financeira.tab_transacao t, apl_financeira.tab_conta c
       where t.idconta = c.idconta
         and t.tipotransacao = 1 --transacao de debito
         and t.data between p_dt_ini and nvl(p_dt_fim, sysdate)
         and c.idcliente = v_idcliente;
    
      select count(0) into v_count_cred
        from apl_financeira.tab_transacao t, apl_financeira.tab_conta c
       where t.idconta = c.idconta
         and t.tipotransacao = 2 --transacao de credito
         and t.data between p_dt_ini and nvl(p_dt_fim, sysdate)
         and c.idcliente = v_idcliente;
         
      select sum(t.comissao) into v_comissao_cred
        from apl_financeira.tab_transacao t, apl_financeira.tab_conta c
       where t.idconta = c.idconta
         and t.tipotransacao = 2 --transacao de credito
         and t.data between p_dt_ini and nvl(p_dt_fim, sysdate)
         and c.idcliente = v_idcliente;
    end if;
    
    open p_lista_retorno
    for select
        x.nome,
        to_char(v_dt_ini_cliente,'dd/mm/yyyy') as dtini,
        e.rua,
        e.numero,
        e.complemento,
        e.bairro,
        e.cep,
        e.cidade,
        e.uf,
        v_count_cred as mov_cred,
        v_count_deb as mov_deb,
        (v_count_cred + v_count_deb) as mov_totais,
        (v_comissao_cred + v_comissao_deb) as mov_pag,
        v_saldo_inicial as saldo_inicial,
        v_saldo_total as saldo_atual
    from apl_financeira.tab_cliente x
    left join apl_financeira.tab_endereco e on e.id = x.idcliente
    where x.idcliente = v_idcliente;
    
    p_erro        := 'N';
    p_msg_retorno := 'Busca de relatorio de clientes feita com sucesso.';
  
  exception
    when others then
      open p_lista_retorno for
        select 0 from dual;
      p_erro        := 'S';
      p_msg_retorno := 'Falha ao buscar relatorio de clientes.';
  end;
end;
/
