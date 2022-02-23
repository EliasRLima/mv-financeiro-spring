package mvn.teste.financeiro.model;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class Cliente implements Serializable {

    private static  final long serialVersionUID = 1L;

    @Id @GeneratedValue
    private Integer id;

    private String nome;
    private String cpfcnpj;

    private String endereco; //trocar pela entidade dps

    private String contas; //trocar pelas entidade dps

    private Integer tipopessoa;
    private String telefone;

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCpfcnpj() {
        return cpfcnpj;
    }

    public void setCpfcnpj(String cpfcnpj) {
        this.cpfcnpj = cpfcnpj;
    }
}
