package mvn.teste.financeiro.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class Conta {

    @Id
    @GeneratedValue
    private Integer id;

    private Integer idcliente;
    private Double  saldo;
    private String  instituicao;
    private String  agencia;
    private String  numero;

}
