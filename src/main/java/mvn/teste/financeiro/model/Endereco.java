package mvn.teste.financeiro.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class Endereco {

    @Id
    @GeneratedValue
    private Integer id; //no banco o id de um endereco é o mesmo idcliente

    private String rua;
    private String bairro;
    private String cidade;
    private String estado;

    private Integer numero;
    private Integer cep;
}
