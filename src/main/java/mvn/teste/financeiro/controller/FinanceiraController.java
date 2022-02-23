package mvn.teste.financeiro.controller;

import mvn.teste.financeiro.repository.ClienteRepository;
import mvn.teste.financeiro.service.ClienteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class FinanceiraController {

    @Autowired
    private ClienteService clientes;

    @GetMapping("/")
    public String index(){
        return "index";
    }

    @GetMapping("/clientes")
    public ModelAndView listar(){
        ModelAndView modelAndView = new ModelAndView("listaclientes");
        modelAndView.addObject("clientes", clientes.list());
        return modelAndView;
    }

}
