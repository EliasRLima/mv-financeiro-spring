package mvn.teste.financeiro.repository;

import mvn.teste.financeiro.model.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ClienteRepository extends JpaRepository<Cliente, Long> {

}
