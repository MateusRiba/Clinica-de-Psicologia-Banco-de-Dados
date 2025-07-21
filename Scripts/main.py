from CRUD import *
MENU = """
========= MENU =========
1  Psicólogo
2  Envolvido
3  Paciente
4  Cuidador
5  Acompanha
6  Diagnóstico
7  Sessão
8  Anotação de Sessão
0  Sair
"""

def submenu_psicologo():
    while True:
        op = input("\n(P) Listar | (A) Adicionar | (U) Update Esp. | (D) Delete | Voltar: ").lower()
        if op == "p": list_psicologos()
        elif op == "a":
            add_psicologo(
                input("CRP: "), input("CPF: "), input("Especialidade: "),
                input("Abordagem: "), input("Nome: "),
                input("Endereço: "), input("Data nasc (YYYY-MM-DD): ")
            )
        elif op == "u": upd_psicologo_especialidade(input("CRP: "), input("Nova esp.: "))
        elif op == "d": del_psicologo(input("CRP: "))
        else: break

def submenu_envolvido():
    while True:
        op = input("\n(P) Listar | (A) Adicionar | (U) Update End. | (D) Delete | Voltar: ").lower()
        if op == "p": list_envolvidos()
        elif op == "a":
            add_envolvido(
                input("CPF: "), input("Data nasc (YYYY-MM-DD): "),
                input("Nome: "), input("Endereço: "), input("Sexo [Masculino/Feminino]: ")
            )
        elif op == "u": upd_envolvido_endereco(input("CPF: "), input("Novo end.: "))
        elif op == "d": del_envolvido(input("CPF: "))
        else: break

def submenu_paciente():
    while True:
        op = input("\n(P) Listar | (A) Adicionar | (U) Update Hist. | (D) Delete | Voltar: ").lower()
        if op == "p": list_pacientes()
        elif op == "a":
            add_paciente(
                input("Nº Convênio: "), input("Histórico: "), input("CPF Envolvido: ")
            )
        elif op == "u": upd_paciente_hist(input("Nº Convênio: "), input("Novo hist.: "))
        elif op == "d": del_paciente(input("Nº Convênio: "))
        else: break

def submenu_cuidador():
    while True:
        op = input("\n(P) Listar | (A) Adicionar | (U) Update Papel | (D) Delete | Voltar: ").lower()
        if op == "p": list_cuidadores()
        elif op == "a":
            add_cuidador(input("CPF Envolvido: "), input("Papel: "), input("Nº Convênio: "))
        elif op == "u": upd_cuidador_papel(input("CPF Envolvido: "), input("Novo papel: "))
        elif op == "d": del_cuidador(input("CPF Envolvido: "))
        else: break

def submenu_acompanha():
    while True:
        op = input("\n(P) Listar | (A) Adicionar | (D) Delete | Voltar: ").lower()
        if op == "p": list_acompanha()
        elif op == "a": add_acompanha(input("CRP Psic.: "), input("CPF Envolvido: "))
        elif op == "d": del_acompanha(input("CRP Psic.: "), input("CPF Envolvido: "))
        else: break

def submenu_diagnostico():
    while True:
        op = input("\n(P) Listar | (A) Adicionar | (U) Update Desc. | (D) Delete | Voltar: ").lower()
        if op == "p": list_diagnosticos()
        elif op == "a":
            add_diagnostico(
                input("CID: "), input("Data (YYYY-MM-DD): "), input("Descrição: "),
                input("CRP Psic.: "), input("Nº Convênio: ")
            )
        elif op == "u": upd_diag_desc(input("CID: "), input("Nova descrição: "))
        elif op == "d": del_diagnostico(input("CID: "))
        else: break

def submenu_sessao():
    while True:
        op = input("\n(P) Listar | (A) Adicionar | (U) Update Fim | (D) Delete | Voltar: ").lower()
        if op == "p": list_sessoes()
        elif op == "a":
            add_sessao(
                input("ID: "), input("Tipo [Presencial/Online]: "),
                input("Data (YYYY-MM-DD): "), input("Início (HH:MM): "),
                input("Fim (HH:MM): "), input("CRP Psic.: "), input("Nº Convênio: ")
            )
        elif op == "u": upd_sessao_fim(input("ID: "), input("Novo fim (HH:MM): "))
        elif op == "d": del_sessao(input("ID: "))
        else: break

def submenu_anotacao():
    while True:
        op = input("\n(P) Listar | (A) Adicionar | (U) Update Cont. | (D) Delete | Voltar: ").lower()
        if op == "p": list_anotacoes()
        elif op == "a":
            add_anotacao(
                input("ID Sess.: "), input("Conteúdo: "), input("Tipo: "),
                input("Hora (HH:MM): ")
            )
        elif op == "u":
            upd_anotacao_conteudo(
                input("ID Sess.: "), input("Hora (HH:MM): "),
                input("Novo conteúdo: ")
            )
        elif op == "d": del_anotacao(input("ID Sess.: "), input("Hora (HH:MM): "))
        else: break

SUBMENUS = {
    "1": submenu_psicologo,
    "2": submenu_envolvido,
    "3": submenu_paciente,
    "4": submenu_cuidador,
    "5": submenu_acompanha,
    "6": submenu_diagnostico,
    "7": submenu_sessao,
    "8": submenu_anotacao,
}

def main():
    while True:
        print(MENU)
        choice = input("Escolha: ").strip()
        if choice == "0":
            break
        submenu = SUBMENUS.get(choice)
        if submenu:
            submenu()
        else:
            print("Opção inválida.")

if __name__ == "__main__":
    main()
