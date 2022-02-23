package mvn.teste.financeiro.service;

import mvn.teste.financeiro.model.Cliente;
import mvn.teste.financeiro.repository.ClienteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClienteService {

    @Autowired
    ClienteRepository clienteRepository;

    public List<Cliente> list(){
        return  clienteRepository.findAll();
    }
}
