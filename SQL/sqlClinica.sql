

  -- 0. Limpa tudo --> Util caso queira rodar o script com modificações e ja tenha ele salvo na maquina)
  
  ROLLBACK;

  DROP TABLE IF EXISTS
    anotacao_sessao,
    sessao,
    diagnostico,
    acompanha,
    cuidador,
    paciente,
    envolvido,
    psicologo
  CASCADE;

  /*--------------------------------------------------------------
    1. CRIAÇÃO DO ESQUEMA
  ----------------------------------------------------------------*/
  BEGIN;

  CREATE TABLE Psicologo(
    CRP            CHAR(7)  PRIMARY KEY,  
    CPF            CHAR(11)    NOT NULL UNIQUE,
    Especialidade  VARCHAR(30),
    Abordagem      VARCHAR(30) NOT NULL,
    Nome           VARCHAR(80) NOT NULL,
    Endereço       VARCHAR(100) NOT NULL,
    Data_nascimento DATE       NOT NULL
  );

  CREATE TABLE Envolvido (
    CPF             CHAR(11) PRIMARY KEY,
    Data_Nascimento DATE        NOT NULL,
    Nome            VARCHAR(80) NOT NULL,
    Endereco        VARCHAR(100) NOT NULL,
    Sexo            VARCHAR(10) NOT NULL
                    CHECK (Sexo IN ('Masculino','Feminino'))
  );

  CREATE TABLE Paciente (
    N_convenio     CHAR(11) PRIMARY KEY,
    Historico_Clinico TEXT,
    Envolvido_CPF  CHAR(11) REFERENCES Envolvido(CPF)
  );

  CREATE TABLE Cuidador (
    Envolvido_CPF       CHAR(11) PRIMARY KEY
                        REFERENCES Envolvido(CPF),
    Papel               VARCHAR(30),
    N_convenio_paciente CHAR(11) NOT NULL
                        REFERENCES Paciente(N_convenio)
  );

  CREATE TABLE Acompanha (
    CRP_psicologo CHAR(7)  NOT NULL REFERENCES Psicologo(CRP),
    CPF_envolvido CHAR(11) NOT NULL REFERENCES Envolvido(CPF),
    PRIMARY KEY (crp_psicologo, cpf_envolvido)
  );

  CREATE TABLE Diagnostico (
    CID                 VARCHAR(11) PRIMARY KEY,
    Data_               DATE        NOT NULL,
    Descricao           TEXT        NOT NULL,
    CRP_psicologo       CHAR(7)  NOT NULL REFERENCES Psicologo(CRP),
    N_convenio_paciente CHAR(11) NOT NULL REFERENCES Paciente(N_convenio)
  );

  CREATE TABLE Sessao (
    ID_sessao           INTEGER     PRIMARY KEY,
    Tipo                VARCHAR(12) NOT NULL CHECK (Tipo IN ('Presencial', 'Online')),
    Data_               DATE        NOT NULL,
    Horario_inicio      TIME        NOT NULL,
    Horario_fim         TIME        NOT NULL,
    Duracao             INTERVAL
           GENERATED ALWAYS AS (Horario_fim - Horario_inicio) STORED,
    CRP_psicologo       CHAR(7)  NOT NULL REFERENCES Psicologo(CRP),
    N_convenio_paciente CHAR(11) NOT NULL REFERENCES Paciente(N_convenio)
  );

  CREATE TABLE Anotacao_sessao (
    ID_sessao  INTEGER NOT NULL REFERENCES Sessao(ID_sessao) ON DELETE CASCADE,
    Conteudo   TEXT    NOT NULL,
    Tipo       VARCHAR(30),
    Horario    TIME    NOT NULL
  );

  COMMIT;        

  BEGIN;

  /*--------------------------------------------------------------
    2. INSERÇÃO DE DADOS
  ----------------------------------------------------------------*/
  /* Psicólogo */
  INSERT INTO Psicologo (CRP, CPF, Especialidade, Abordagem, Nome, Endereço, Data_nascimento)
  VALUES 
  ('06/1234','12345678900','Clínica Geral','Psicanalise','Ana Alice Ferraz Araujo','Rua Isaac Markman 23','2003-12-15'),
  ('06/5678','09876543210','Psicologia Infantil','Cognitivo-Comportamental','Bruno Henrique da Silva','Av. das Flores, 200','1995-03-22'),
  ('06/9101','11223344556','Psicologia Organizacional','ACP','Carla Maria Souza','Rua das Orquídeas, 75','1988-07-30'),
  ('06/1213','22334455667',NULL,'Gestalt','Daniela Costa Pereira','Av. das Américas, 500','1990-11-05'),
  ('06/1415','33445566778','Psicologia Educacional','ACP','Eduardo Lima Santos','Rua do Comércio, 150','1985-02-18'),
  ('06/1617','44556677889','Psicologia do Esporte','Cognitivo-Comportamental','Fernanda Alves Rocha','Av. Rio Branco, 300','1992-08-25'),
  ('06/1819','55667788990','Psicologia Social','Fenomenológica','Gustavo Henrique Martins','Rua das Palmeiras, 80','1987-04-10'),
  ('06/2021','66778899001','Psicologia Forense','Psicanalise','Helena Cristina Dias','Av. Paulista, 1000','1993-09-15'),
  ('06/2223','77889900112','Psicologia Hospitalar','Cognitivo-Comportamental','Igor Santos Oliveira','Rua das Acácias, 60','1989-01-20'),
  ('06/2425','88990011223','Psicologia Comunitária','ACP','Juliana Ferreira Costa','Av. Liberdade, 400','1996-05-30'),
  ('06/2627','99001122334','Psicologia do Trânsito','Gestalt','Karla Regina Almeida','Rua das Flores, 90','1984-10-05'),
  ('06/2829','00112233445','Psicologia do Trabalho','ACP','Leonardo Souza Lima','Av. Brasil, 250','1991-06-12'),
  ('06/3013','11122334565',NULL,'Cognitivo-Comportamental','Beatriz Vitoria Kauan','Rua das Oliveiras, 10','1994-04-21'),
  ('06/3014','11122334566',NULL,'Cognitivo-Comportamental','Lara Holanda','Av. Central, 55','1992-08-13'),
  ('06/3015','11122334567',NULL,'Cognitivo-Comportamental','Aline Dunnow','Rua do Sol, 77','1989-12-05'),
  ('06/3016','11122334568',NULL,'ACP','Daniele Araujo','Av. das Nações, 101','1990-03-17'),
  ('06/3017','11122334569',NULL,'Gestalt','João Dunnow','Rua das Laranjeiras, 22','1987-07-29'),
  ('06/3018','11122334570',NULL,'Gestalt','Eduarda Nazario','Av. Primavera, 88','1995-11-02')
  ON CONFLICT (CRP) DO NOTHING;

  /* Envolvidos */
  INSERT INTO Envolvido (CPF, Data_Nascimento, Nome, Endereco, Sexo) VALUES
  ('11111111111','2000-05-20','João Pedro da Silva','Av. Brasil, 100','Masculino'),
  ('22222222222','1998-09-12','Maria Clara Gonçalves','Rua das Palmeiras, 45','Feminino'),
  ('33333333333','1975-01-30','Carlos Alberto da Silva','Rua das Acácias, 12','Masculino'),
  ('44444444444','1978-08-14','Patrícia Fernandes Lima','Av. Liberdade, 321','Feminino'),
  ('55555555555','1992-03-15','Mateus Ribeiro','Rua das Oliveiras, 50','Masculino'),
  ('66666666666','1985-07-22','Luiza Trigueiro','Av. Central, 200','Feminino'),
  ('77777777777','1999-11-30','Beatriz dos Anjos','Rua do Sol, 77','Feminino'),
  ('88888888888','1980-02-18','Rafael Souza','Rua das Laranjeiras, 22','Masculino'),
  ('99999999999','1972-06-05','Fernanda Lima','Av. Primavera, 88','Feminino'),
  ('10101010101','1994-09-12','Lucas Martins','Rua das Acácias, 60','Masculino'),
  ('12121212121','1987-12-25','Amanda Costa','Av. Liberdade, 400','Feminino'),
  ('13131313131','1996-04-17','Gabriel Oliveira','Rua das Flores, 90','Masculino'),
  ('14141414141','1983-08-29','Juliana Ferreira','Av. Brasil, 250','Feminino'),
  ('15151515151','1991-01-03','Rodrigo Almeida','Rua das Oliveiras, 10','Masculino'),
  ('16161616161','1989-05-21','Carolina Souza','Av. Central, 55','Feminino'),
  ('17171717171','1993-10-14','Bruno Henrique','Rua do Sol, 77','Masculino'),
  ('18181818181','1986-03-28','Patricia Santos','Av. das Nações, 101','Feminino'),
  ('19191919191','1998-07-09','Eduardo Lima','Rua das Laranjeiras, 22','Masculino'),
  ('20202020202','1984-11-02','Daniela Pereira','Av. Primavera, 88','Feminino'),
  ('21212121212','1997-02-15','Helena Dias','Rua das Acácias, 60','Feminino'),
  ('23232323232','1982-06-27','Igor Oliveira','Av. Liberdade, 400','Masculino'),
  ('24242424242','1995-09-19','Karla Almeida','Rua das Flores, 90','Feminino');

  /* Pacientes */
  INSERT INTO Paciente (N_convenio, Historico_Clinico, Envolvido_CPF) VALUES
  ('91000000001','Ansiedade generalizada','11111111111'),
  ('91000000002','Episódio depressivo leve','22222222222'),
  ('91000000003','Transtorno obsessivo-compulsivo','33333333333'),
  ('91000000004','Transtorno de déficit de atenção e hiperatividade','44444444444'),
  ('91000000005','Fobia social','55555555555'),
  ('91000000006','Transtorno bipolar','66666666666'),
  ('91000000007','Transtorno de pânico','77777777777');

  /* Cuidadores */
  INSERT INTO Cuidador (Envolvido_CPF, Papel, N_convenio_paciente) VALUES
  ('55555555555','Mãe','91000000003'),
  ('66666666666','Pai','91000000004'),
  ('77777777777','Tia','91000000005'),
  ('88888888888','Avó','91000000006'),
  ('99999999999','Irmão','91000000007'),
  ('10101010101','Padrasto','91000000001'),
  ('12121212121','Madrasta','91000000002'),
  ('13131313131','Tio','91000000003'),
  ('14141414141','Prima','91000000004'),
  ('15151515151','Avô','91000000005');

  /* Acompanha */
  INSERT INTO Acompanha (CRP_psicologo, CPF_envolvido) VALUES
  ('06/1234','11111111111'),
  ('06/1234','22222222222'),
  ('06/5678','33333333333'),
  ('06/5678','44444444444'),
  ('06/9101','55555555555'),
  ('06/9101','66666666666'),
  ('06/1213','77777777777'),
  ('06/1213','88888888888'),
  ('06/1415','99999999999'),
  ('06/1415','10101010101'),
  ('06/1617','12121212121'),
  ('06/1617','13131313131'),
  ('06/1819','14141414141'),
  ('06/1819','15151515151'),
  ('06/2021','16161616161'),
  ('06/2021','17171717171'),
  ('06/2223','18181818181'),
  ('06/2223','19191919191'),
  ('06/2425','20202020202'),
  ('06/2425','21212121212'),
  ('06/2627','23232323232'),
  ('06/2627','24242424242');

  /* Diagnósticos */
  INSERT INTO Diagnostico (CID, Data_, Descricao, CRP_psicologo, N_convenio_paciente) VALUES
  ('F41.1','2025-06-01','Transtorno de Ansiedade Generalizada','06/1234','91000000001'),
  ('F33.0','2025-06-02','Episódio Depressivo Leve','06/1234','91000000002'),
  ('F42','2025-06-03','Transtorno Obsessivo-Compulsivo','06/5678','91000000003'),
  ('F90.0','2025-06-04','Transtorno de Déficit de Atenção e Hiperatividade','06/5678','91000000004'),
  ('F40.1','2025-06-05','Fobia Social','06/9101','91000000005'),
  ('F31.9','2025-06-06','Transtorno Bipolar','06/9101','91000000006'),
  ('F41.0','2025-06-07','Transtorno de Pânico','06/1213','91000000007'),
  ('F32.1','2025-06-08','Episódio Depressivo Moderado','06/1415','91000000001'),
  ('F43.2','2025-06-09','Transtorno de Adaptação','06/1617','91000000002'),
  ('F84.0','2025-06-10','Transtorno do Espectro Autista','06/1819','91000000003'),
  ('F50.0','2025-06-11','Anorexia Nervosa','06/2021','91000000004'),
  ('F51.0','2025-06-12','Insônia Primária','06/2223','91000000005');

  /* Sessões */
  INSERT INTO Sessao (ID_sessao, Tipo, Data_, Horario_inicio, Horario_fim,CRP_psicologo, N_convenio_paciente)
  VALUES
    (1,'Presencial','2025-06-10','14:00','15:00','06/1234','91000000001'),
    (2,'Online'    ,'2025-06-12','09:00','10:00','06/1234','91000000001'),
    (3,'Presencial','2025-06-11','10:00','11:00','06/1234','91000000002'),
    (4,'Online'    ,'2025-06-13','16:00','17:00','06/5678','91000000003'),
    (5,'Presencial','2025-06-14','08:00','09:00','06/5678','91000000004'),
    (6,'Online'    ,'2025-06-15','11:00','12:00','06/9101','91000000005'),
    (7,'Presencial','2025-06-16','13:00','14:00','06/9101','91000000006'),
    (8,'Online'    ,'2025-06-17','15:00','16:00','06/1213','91000000007'),
    (9,'Presencial','2025-06-18','10:00','11:00','06/1415','91000000001'),
    (10,'Online'   ,'2025-06-19','09:00','10:00','06/1617','91000000002'),
    (11,'Presencial','2025-06-20','14:00','15:00','06/1819','91000000003'),
    (12,'Online'   ,'2025-06-21','08:00','09:00','06/2021','91000000004'),
    (13,'Presencial','2025-06-22','11:00','12:00','06/2223','91000000005');

  /* Anotações */
  INSERT INTO Anotacao_sessao (ID_sessao, Conteudo, Tipo, Horario) VALUES
  (1,'Paciente relatou aumento da ansiedade nos últimos dias','Observação','14:30'),
  (1,'Aplicada técnica de respiração diafragmática','Técnica','14:45'),
  (2,'Revisão de tarefas de casa sobre psicoeducação','Observação','09:20'),
  (3,'Paciente mostrou melhora do humor','Observação','10:40'),
  (4,'Paciente apresentou sintomas obsessivos durante a sessão','Observação','16:30'),
  (4,'Iniciada exposição gradual a situações temidas','Intervenção','16:45'),
  (5,'Paciente relatou dificuldades de concentração','Observação','08:30'),
  (5,'Aplicada técnica de mindfulness','Técnica','08:50'),
  (6,'Paciente demonstrou preocupação excessiva com desempenho escolar','Observação','11:30'),
  (6,'Discutida importância do equilíbrio entre estudo e lazer','Orientação','11:45'),
  (7,'Paciente relatou episódios de tristeza intensa','Observação','13:30'),
  (7,'Explorada rede de apoio familiar','Intervenção','13:50'),
  (8,'Paciente apresentou melhora nos sintomas de pânico','Observação','15:30'),
  (8,'Reforçada prática de técnicas de respiração','Técnica','15:45'),
  (9,'Paciente relatou dificuldades de adaptação ao novo ambiente escolar','Observação','10:30'),
  (9,'Sugestão de atividades de integração social','Orientação','10:50'),
  (10,'Paciente apresentou insônia recorrente','Observação','09:30'),
  (10,'Orientação sobre higiene do sono','Orientação','09:45'),
  (11,'Paciente demonstrou interesse em atividades artísticas','Observação','14:30'),
  (11,'Incentivo à expressão emocional através da arte','Intervenção','14:45'),
  (12,'Paciente relatou melhora dos sintomas depressivos','Observação','08:30'),
  (12,'Reforçada importância do acompanhamento regular','Orientação','08:50'),
  (13,'Paciente apresentou redução dos sintomas ansiosos','Observação','11:30'),
  (13,'Aplicada técnica de relaxamento muscular progressivo','Técnica','11:45');
  COMMIT;

  /*--------------------------------------------------------------
    3. CONSULTAS  
  ----------------------------------------------------------------*/

  
  SELECT * FROM Psicologo;

  SELECT * FROM Envolvido;

  SELECT * FROM Paciente;

  SELECT * FROM Sessao;

  SELECT * FROM Diagnostico;

  SELECT * FROM Anotacao_sessao;

  SELECT * FROM Cuidador;

  SELECT * FROM Acompanha;


  -- Consulta aninhada: Pacientes que têm diagnóstico de 'Transtorno de Ansiedade Generalizada'
  SELECT Nome
  FROM Envolvido
  WHERE CPF IN (
    SELECT Envolvido_CPF
    FROM Paciente
    WHERE N_convenio IN (
      SELECT N_convenio_paciente
      FROM Diagnostico
      WHERE Descricao = 'Transtorno de Ansiedade Generalizada'
    )
  );
 
  -- Consulta aninhada: Pacientes que não possuem cuidador --> Corrigido
  SELECT e.Nome
  FROM Envolvido e
  JOIN Paciente p ON e.CPF = p.Envolvido_CPF
  WHERE p.N_convenio NOT IN (
    SELECT N_convenio_paciente
    FROM Cuidador
  );

  -- Comparação de conjunto: Psicólogos que não têm nenhum diagnóstico registrado
  SELECT CRP, Nome
  FROM Psicologo
  WHERE CRP NOT IN (
    SELECT DISTINCT CRP_psicologo
    FROM Diagnostico
  );
  
  -- Função EXISTS: Sessões que possuem anotações do tipo 'Técnica' (Impede repetição de sessões)
  SELECT s.ID_sessao, s.Data_, s.Tipo
  FROM Sessao s
  WHERE EXISTS (
    SELECT 1
    FROM Anotacao_sessao a
    WHERE a.ID_sessao = s.ID_sessao
      AND a.Tipo = 'Técnica'
  );

  -- Consulta aninhada correlacionada: Pacientes que têm mais de uma anotação por sessão
  SELECT p.Nome
  FROM Envolvido p
  WHERE EXISTS (
    SELECT 1
    FROM Paciente pa
    WHERE pa.Envolvido_CPF = p.CPF
      AND EXISTS (
        SELECT 1
        FROM Sessao s
        WHERE s.N_convenio_paciente = pa.N_convenio
          AND (
            SELECT COUNT(*)
            FROM Anotacao_sessao a
            WHERE a.ID_sessao = s.ID_sessao
          ) > 1
      )
  );

  -- MAX: Sessão mais longa registrada
  SELECT s.ID_sessao, s.Data_, EXTRACT(EPOCH FROM s.Duracao)/60 AS Duracao_Minutos
  FROM Sessao s
  WHERE s.Duracao = (
    SELECT MAX(Duracao)
    FROM Sessao
  );

  -- Uso de JOIN: Diagnósticos e nome do psicólogo responsável
  SELECT d.CID, d.Descricao, d.Data_, p.Nome AS Psicologo
  FROM Diagnostico d
  JOIN Psicologo p ON d.CRP_psicologo = p.CRP;

  -- GROUP BY e HAVING: Psicólogos com mais de 2 pacientes acompanhados
  SELECT ps.Nome, COUNT(a.CPF_envolvido) AS Total_Pacientes
  FROM Psicologo ps
  JOIN Acompanha a ON ps.CRP = a.CRP_psicologo
  GROUP BY ps.Nome
  HAVING COUNT(a.CPF_envolvido) > 2;

 /*--------------------------------------------------------------
    3. Alters para o Projeto
  ----------------------------------------------------------------*/

  -- Acompanha
ALTER TABLE Acompanha
    DROP CONSTRAINT acompanha_crp_psicologo_fkey,
    ADD  CONSTRAINT acompanha_crp_psicologo_fkey
         FOREIGN KEY (CRP_psicologo)
         REFERENCES Psicologo(CRP)
         ON DELETE CASCADE;

-- Sessao
ALTER TABLE Sessao
    DROP CONSTRAINT sessao_crp_psicologo_fkey,
    ADD  CONSTRAINT sessao_crp_psicologo_fkey
         FOREIGN KEY (CRP_psicologo)
         REFERENCES Psicologo(CRP)
         ON DELETE CASCADE;

-- Diagnostico
ALTER TABLE Diagnostico
    DROP CONSTRAINT diagnostico_crp_psicologo_fkey,
    ADD  CONSTRAINT diagnostico_crp_psicologo_fkey
         FOREIGN KEY (CRP_psicologo)
         REFERENCES Psicologo(CRP)
         ON DELETE CASCADE;

-- Cuidador → Envolvido
ALTER TABLE Cuidador
  DROP CONSTRAINT cuidador_envolvido_cpf_fkey,
  ADD  CONSTRAINT cuidador_envolvido_cpf_fkey
       FOREIGN KEY (Envolvido_CPF)
       REFERENCES Envolvido(CPF)
       ON DELETE CASCADE;

-- Acompanha → Envolvido
ALTER TABLE Acompanha
  DROP CONSTRAINT acompanha_cpf_envolvido_fkey,
  ADD  CONSTRAINT acompanha_cpf_envolvido_fkey
       FOREIGN KEY (CPF_envolvido)
       REFERENCES Envolvido(CPF)
       ON DELETE CASCADE;

-- Paciente → Envolvido
ALTER TABLE Paciente
  DROP CONSTRAINT paciente_envolvido_cpf_fkey,
  ADD  CONSTRAINT paciente_envolvido_cpf_fkey
       FOREIGN KEY (Envolvido_CPF)
       REFERENCES Envolvido(CPF)
       ON DELETE CASCADE;
