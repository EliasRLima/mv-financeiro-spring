--rodar no sql plus (terminal oracle) ou comand window do PL/SQL Developer

alter session set "_ORACLE_SCRIPT"=true;
create user apl_financeira
identified by "123";

alter user apl_financeira quota unlimited on USERS;
GRANT CREATE SESSION TO apl_financeira WITH ADMIN OPTION;

create sequence apl_financeira.seq_id_transacao
minvalue 1
maxvalue 999999999999999
start with 1
increment by 1;

create table apl_financeira.tab_tipocliente(id number primary key, descricao varchar2(100));
insert into apl_financeira.tab_tipocliente(id, descricao) values (1, 'Pessoa Fisica');
insert into apl_financeira.tab_tipocliente(id, descricao) values (2, 'Pessoa Juridica');

create table apl_financeira.tab_cliente(idcliente number primary key, nome varchar2(500), cpfcnpj varchar2(14) not null,  tipocliente number, telefone varchar2(100));
insert into apl_financeira.tab_cliente(idcliente, nome, cpfcnpj,  tipocliente, telefone) values (1, 'Joao', '12312312312',  1, '+55 00 90101-0101');
insert into apl_financeira.tab_cliente(idcliente, nome, cpfcnpj,  tipocliente, telefone) values (2, 'Maria', '45645645610001',  2, '+55 00 90202-0202');
insert into apl_financeira.tab_cliente(idcliente, nome, cpfcnpj,  tipocliente, telefone) values (3, 'Alice', '78978978978', 1, '+55 00 90303-0303');

alter table apl_financeira.tab_CLIENTE
add constraint fk_tipo foreign key (tipocliente)
references apl_financeira.tab_tipocliente (id);

alter table apl_financeira.tab_CLIENTE
add constraint UQ_C unique (CPFCNPJ);

create table apl_financeira.tab_endereco(id number primary key, rua varchar2(100), numero number, complemento varchar2(100), bairro varchar2(100), cep varchar2(10), cidade varchar2(100), uf varchar2(2));
insert into apl_financeira.tab_endereco(id, rua, numero, complemento, bairro, cep, cidade, uf) values (1, 'Av. principal', 727, 'Apartamento 211', 'Centro', '00000-000', 'City of Brazil', 'CG');

alter table apl_financeira.tab_ENDERECO
add constraint fk_id foreign key (id)
references apl_financeira.tab_cliente(idcliente);

create table apl_financeira.tab_conta(idconta number primary key, idcliente number, saldo number, instituicao varchar2(100), agencia varchar2(100), numero varchar2(100));
insert into apl_financeira.tab_conta(idconta, idcliente, saldo, instituicao, agencia, numero) values (1, 1, 10.0, 'NU BANK', '0001', '00000');

alter table apl_financeira.tab_CONTA
add constraint fk_id_cc foreign key (idcliente)
references apl_financeira.tab_cliente(idcliente);

create table apl_financeira.tab_tipotransacao(id number primary key, descricao varchar2(100));
insert into apl_financeira.tab_tipotransacao(id, descricao) values (1, 'debito');
insert into apl_financeira.tab_tipotransacao(id, descricao) values (2, 'credito');

create table apl_financeira.tab_transacao(idtransacao number primary key, idconta number, tipotransacao number, valor number not null, comissao number not null, data date not null);
insert into apl_financeira.tab_transacao(idtransacao,idconta, tipotransacao, valor, comissao, data) values (1, 1, 2, 10.0, 1.0, (sysdate-30));

alter table apl_financeira.tab_TRANSACAO
add constraint fk_id_tt foreign key (tipotransacao)
references apl_financeira.tab_tipotransacao(id);

alter table apl_financeira.tab_TRANSACAO
add constraint fk_id_tc foreign key (idconta)
references apl_financeira.tab_conta(idconta);

commit;
