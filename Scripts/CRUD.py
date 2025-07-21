from tabulate import tabulate
from Database import fetch_all, execute

# PSICÓLOGO 
def add_psicologo(crp, cpf, espe, abor, nome, end, nasc):
    execute("""
        INSERT INTO Psicologo
        (CRP, CPF, Especialidade, Abordagem, Nome, Endereço, Data_nascimento)
        VALUES (%s,%s,%s,%s,%s,%s,%s) ON CONFLICT (CRP) DO NOTHING
    """, (crp, cpf, espe, abor, nome, end, nasc))

def list_psicologos():
    _print("Psicólogo", fetch_all("SELECT * FROM Psicologo ORDER BY Nome"),
           ["CRP","CPF","Esp.","Abord.","Nome","Endereço","Nasc."])

def upd_psicologo_especialidade(crp, nova):
    execute("UPDATE Psicologo SET Especialidade=%s WHERE CRP=%s", (nova, crp))

def del_psicologo(crp):
    execute("DELETE FROM Psicologo WHERE CRP=%s", (crp,))

# ENVOLVIDO 
def add_envolvido(cpf, data, nome, end, sexo):
    execute("""
        INSERT INTO Envolvido
        (CPF, Data_Nascimento, Nome, Endereco, Sexo)
        VALUES (%s,%s,%s,%s,%s)
    """, (cpf, data, nome, end, sexo))

def list_envolvidos():
    _print("Envolvido",
           fetch_all("SELECT * FROM Envolvido ORDER BY Nome"),
           ["CPF","Nasc.","Nome","Endereço","Sexo"])

def upd_envolvido_endereco(cpf, novo_end):
    execute("UPDATE Envolvido SET Endereco=%s WHERE CPF=%s", (novo_end, cpf))

def del_envolvido(cpf):
    execute("DELETE FROM Envolvido WHERE CPF=%s", (cpf,))

# PACIENTE 
def add_paciente(nconv, hist, cpf_env):
    execute("""
        INSERT INTO Paciente (N_convenio, Historico_Clinico, Envolvido_CPF)
        VALUES (%s,%s,%s)
    """, (nconv, hist, cpf_env))

def list_pacientes():
    _print("Paciente",
           fetch_all("SELECT * FROM Paciente ORDER BY N_convenio"),
           ["Nº Convênio","Histórico","CPF Envolvido"])

def upd_paciente_hist(nconv, novo_hist):
    execute("UPDATE Paciente SET Historico_Clinico=%s WHERE N_convenio=%s",
            (novo_hist, nconv))

def del_paciente(nconv):
    #Delete dependents first to avoid FK violation
    execute("DELETE FROM Cuidador WHERE N_convenio_paciente=%s", (nconv,))
    execute("DELETE FROM Diagnostico WHERE N_convenio_paciente=%s", (nconv,))
    execute("DELETE FROM Sessao WHERE N_convenio_paciente=%s", (nconv,))
    execute("DELETE FROM Acompanha WHERE CPF_envolvido IN (SELECT Envolvido_CPF FROM Paciente WHERE N_convenio=%s)", (nconv,))
    execute("DELETE FROM Paciente WHERE N_convenio=%s", (nconv,))

# CUIDADOR 
def add_cuidador(cpf_env, papel, nconv):
    execute("""
        INSERT INTO Cuidador (Envolvido_CPF, Papel, N_convenio_paciente)
        VALUES (%s,%s,%s)
    """, (cpf_env, papel, nconv))

def list_cuidadores():
    _print("Cuidador",
           fetch_all("SELECT * FROM Cuidador ORDER BY Envolvido_CPF"),
           ["CPF Env.","Papel","Nº Convênio"])

def upd_cuidador_papel(cpf_env, novo):
    execute("UPDATE Cuidador SET Papel=%s WHERE Envolvido_CPF=%s",
            (novo, cpf_env))

def del_cuidador(cpf_env):
    execute("DELETE FROM Cuidador WHERE Envolvido_CPF=%s", (cpf_env,))

# ACOMPANHA 
def add_acompanha(crp, cpf_env):
    execute("""
        INSERT INTO Acompanha (CRP_psicologo, CPF_envolvido)
        VALUES (%s,%s)
    """, (crp, cpf_env))

def list_acompanha():
    _print("Acompanha",
           fetch_all("SELECT * FROM Acompanha ORDER BY CRP_psicologo"),
           ["CRP Psic.","CPF Env."])

def del_acompanha(crp, cpf_env):
    execute("DELETE FROM Acompanha WHERE CRP_psicologo=%s AND CPF_envolvido=%s",
            (crp, cpf_env))

# DIAGNÓSTICO 
def add_diagnostico(cid, data, desc, crp, nconv):
    execute("""
        INSERT INTO Diagnostico
        (CID, Data_, Descricao, CRP_psicologo, N_convenio_paciente)
        VALUES (%s,%s,%s,%s,%s)
    """, (cid, data, desc, crp, nconv))

def list_diagnosticos():
    _print("Diagnóstico",
           fetch_all("SELECT * FROM Diagnostico ORDER BY Data_ DESC"),
           ["CID","Data","Descrição","CRP Psic.","Nº Conv."])

def upd_diag_desc(cid, nova_desc):
    execute("UPDATE Diagnostico SET Descricao=%s WHERE CID=%s",
            (nova_desc, cid))

def del_diagnostico(cid):
    execute("DELETE FROM Diagnostico WHERE CID=%s", (cid,))

# SESSÃO 
def add_sessao(id_sess, tipo, data, ini, fim, crp, nconv):
    execute("""
        INSERT INTO Sessao
        (ID_sessao, Tipo, Data_, Horario_inicio, Horario_fim,
         CRP_psicologo, N_convenio_paciente)
        VALUES (%s,%s,%s,%s,%s,%s,%s)
    """, (id_sess, tipo, data, ini, fim, crp, nconv))

def list_sessoes():
    _print("Sessão",
           fetch_all("SELECT * FROM Sessao ORDER BY ID_sessao"),
           ["ID","Tipo","Data","Início","Fim","CRP Psic.","Nº Conv."])

def upd_sessao_fim(id_sess, novo_fim):
    execute("UPDATE Sessao SET Horario_fim=%s WHERE ID_sessao=%s",
            (novo_fim, id_sess))

def del_sessao(id_sess):
    execute("DELETE FROM Sessao WHERE ID_sessao=%s", (id_sess,))

# ANOTAÇÃO SESSÃO 
def add_anotacao(id_sess, conteudo, tipo, hora):
    execute("""
        INSERT INTO Anotacao_sessao (ID_sessao, Conteudo, Tipo, Horario)
        VALUES (%s,%s,%s,%s)
    """, (id_sess, conteudo, tipo, hora))

def list_anotacoes():
    _print("Anotação",
           fetch_all("SELECT * FROM Anotacao_sessao ORDER BY ID_sessao, Horario"),
           ["ID Sess.","Conteúdo","Tipo","Hora"])

def upd_anotacao_conteudo(id_sess, hora, novo):
    execute("""
        UPDATE Anotacao_sessao SET Conteudo=%s
        WHERE ID_sessao=%s AND Horario=%s
    """, (novo, id_sess, hora))

def del_anotacao(id_sess, hora):
    execute("""
        DELETE FROM Anotacao_sessao
        WHERE ID_sessao=%s AND Horario=%s
    """, (id_sess, hora))

# util interno 
def _print(titulo, rows, headers):
    print(f"\n=== {titulo} ===")
    print(tabulate(rows, headers=headers, tablefmt="mixed_grid"))
    print()
