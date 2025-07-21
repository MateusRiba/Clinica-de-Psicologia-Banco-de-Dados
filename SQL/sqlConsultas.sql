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

  -- "Psicólogos que realizaram sessões com apenas um tipo de atendimento (presencial ou online)."

  SELECT ps.CRP, ps.Nome
  FROM Psicologo ps
  JOIN Sessao s ON ps.CRP = s.CRP_psicologo
  GROUP BY ps.CRP, ps.Nome
  HAVING COUNT(DISTINCT s.Tipo) = 1;

  -- Pacientes com mais de uma sessão — com duração média e máxima //certo
  SELECT e.Nome AS Paciente,
    COUNT(s.ID_sessao) AS Total_Sessoes,
    AVG(EXTRACT(EPOCH FROM s.Duracao)/60) AS Duracao_Media_Minutos, -- Precisa ficar explicado esse funcionamento de EPOCH*
    MAX(EXTRACT(EPOCH FROM s.Duracao)/60) AS Maior_Duracao_Minutos
  FROM Sessao s
  JOIN Paciente p ON s.N_convenio_paciente = p.N_convenio
  JOIN Envolvido e ON p.Envolvido_CPF = e.CPF
  GROUP BY e.Nome
  HAVING COUNT(s.ID_sessao) > 1;



  -- GROUP BY e HAVING: Psicólogos com mais de 2 pacientes acompanhados
  SELECT ps.Nome, COUNT(a.CPF_envolvido) AS Total_Pacientes
  FROM Psicologo ps
  JOIN Acompanha a ON ps.CRP = a.CRP_psicologo
  GROUP BY ps.Nome
  HAVING COUNT(a.CPF_envolvido) > 1;



