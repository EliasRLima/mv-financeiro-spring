create or replace package apl_financeira.pck_conta is

  -- Author  : elias

  function fnc_busca_valor_comissao(p_idconta in number) return number;

  procedure stp_atualiza_saldo(p_idconta in number);

  procedure stp_busca_conta(p_cpfcnpj       in varchar2,
                            p_lista_retorno out apl_financeira.pck_tipos.t_cursor,
                            p_erro          out varchar2,
                            p_msg_retorno   out varchar2);
                            
  procedure stp_depositar(p_idconta     in number,
                          p_valor       in number,
                          p_erro        out varchar2,
                          p_msg_retorno out varchar2);
  
  procedure stp_transferir(p_idconta     in number,
                          p_valor       in number,
                          p_erro        out varchar2,
                          p_msg_retorno out varchar2);

end;
/
create or replace package body apl_financeira.pck_conta is

  function fnc_busca_valor_comissao(p_idconta in number) return number is
    v_count    number;
    v_comissao number;
  begin
    select count(0) + 1
      into v_count
      from apl_financeira.tab_transacao t
     where t.idconta = p_idconta;
  
    if v_count < 10 then
      v_comissao := 1.0;
    elsif v_count between 10 and 20 then
      v_comissao := 0.75;
    else
      v_comissao := 0.5;
    end if;
  
    return v_comissao;
  end;

  procedure stp_atualiza_saldo(p_idconta in number) is
    v_saldo_atualizado number := 0;
  begin
    for r1 in (select t.tipotransacao, t.valor, t.comissao, t.data
                 from apl_financeira.Tab_Transacao t
                where t.idconta = p_idconta
                order by t.data desc) loop
      if r1.tipotransacao = 1 then
        v_saldo_atualizado := v_saldo_atualizado - (r1.valor + r1.comissao);
      elsif r1.tipotransacao = 2 then
        v_saldo_atualizado := v_saldo_atualizado + (r1.valor - r1.comissao);
      end if;
    end loop;
  
    update apl_financeira.tab_conta c
       set c.saldo = v_saldo_atualizado
     where c.idconta = p_idconta;
  
  end;

  procedure stp_busca_conta(p_cpfcnpj       in varchar2,
                            p_lista_retorno out apl_financeira.pck_tipos.t_cursor,
                            p_erro          out varchar2,
                            p_msg_retorno   out varchar2) is
  begin
    open p_lista_retorno for
      select con.idconta,
             con.idcliente,
             con.saldo,
             (con.saldo - fnc_busca_valor_comissao(con.idconta)) as saldo_disponivel,
             con.instituicao,
             con.agencia,
             con.numero
        from apl_financeira.tab_conta con, apl_financeira.tab_cliente cli
       where cli.idcliente = con.idconta
         and cli.cpfcnpj = p_cpfcnpj;
  
    p_erro        := 'N';
    p_msg_retorno := 'Contas consultadas com sucesso.';
  exception
    when others then
      p_erro        := 'S';
      p_msg_retorno := 'Falha ao consultar as contas.';
  end;

  procedure stp_depositar(p_idconta     in number,
                          p_valor       in number,
                          p_erro        out varchar2,
                          p_msg_retorno out varchar2) is
  
  begin
  
    apl_financeira.pck_transacao_inc.executa(p_idconta         => p_idconta,
                                             p_tipo_transacao  => 2,
                                             p_valor_transacao => p_valor,
                                             p_erro            => p_erro,
                                             p_msg_retorno     => p_msg_retorno);
  
    if p_erro = 'N' then
      p_msg_Retorno := 'Deposito efetuado.';
    end if;
  exception
    when others then
      p_erro        := 'S';
      p_msg_retorno := 'Falha ao realizar deposito.';
  end;

  procedure stp_transferir(p_idconta     in number,
                          p_valor       in number,
                          p_erro        out varchar2,
                          p_msg_retorno out varchar2) is
    v_saldo_disponivel number;
  begin
  
    select (con.saldo - fnc_busca_valor_comissao(con.idconta)) into v_saldo_disponivel
        from apl_financeira.tab_conta con
       where con.idconta = p_idconta;
       
    if p_valor > v_saldo_disponivel then
       p_erro := 'S';
       p_msg_retorno := 'O saldo é insuficiente.';
       return;
    end if;
         
    apl_financeira.pck_transacao_inc.executa(p_idconta         => p_idconta,
                                             p_tipo_transacao  => 1,
                                             p_valor_transacao => p_valor,
                                             p_erro            => p_erro,
                                             p_msg_retorno     => p_msg_retorno);
  
    if p_erro = 'N' then
      p_msg_Retorno := 'Movimentacao efetuada.';
    end if;
  exception
    when others then
      p_erro        := 'S';
      p_msg_retorno := 'Falha ao realizar movimentacao.';
  end;
end;
/
