create or replace package apl_financeira.pck_transacao_inc is

  -- Author  : elias 

  procedure executa(p_idconta         in number,
                    p_tipo_transacao  in number,
                    p_valor_transacao in number,
                    p_erro            out varchar2,
                    p_msg_retorno     out varchar2);

end;
/
create or replace package body apl_financeira.pck_transacao_inc is

  procedure executa(p_idconta         in number,
                    p_tipo_transacao  in number,
                    p_valor_transacao in number,
                    p_erro            out varchar2,
                    p_msg_retorno     out varchar2) is
    v_count    number;
    v_comissao number;
  
  begin
  
    select count(0)
      into v_count
      from apl_financeira.tab_conta t
     where t.idconta = p_idconta;
  
    if v_count = 0 then
      p_erro        := 'S';
      p_msg_retorno := 'Conta nao localizada.';
    end if;
  
    v_comissao := apl_financeira.pck_conta.fnc_busca_valor_comissao(p_idconta);
  
    insert into apl_financeira.tab_transacao
      (idtransacao, idconta, tipotransacao, valor, comissao, data)
    values
      (apl_financeira.seq_id_transacao.nextval,
       p_idconta,
       p_tipo_transacao,
       p_valor_transacao,
       v_comissao,
       sysdate);
  
    p_erro        := 'N';
    p_msg_retorno := 'Transacao inserida com sucesso.';
  exception
    when others then
      p_erro        := 'S';
      p_msg_retorno := 'Falha ao lançar transacao.';
  end;

end;
/
