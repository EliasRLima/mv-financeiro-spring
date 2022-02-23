
function atualizar(elemento){
            let classe = 'nav-link branco'
            document.getElementById("mn_ini").className = classe
            document.getElementById("mn_cli").className = classe
            document.getElementById("mn_con").className = classe
            document.getElementById("mn_end").className = classe
            document.getElementById(elemento).className = 'nav-link active'
}
