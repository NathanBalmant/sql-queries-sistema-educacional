/*
Questao 1
*/
SELECT  pe.nome AS nomeProfessor, 
       COUNT(d.codDisciplina) AS numDisciplinas,
       p.numCarteira
FROM Professor p
LEFT JOIN Pessoa pe ON p.codPessoa = pe.codPessoa
LEFT JOIN Disciplina d ON p.codPessoa = d.codPessoaProfessor
GROUP BY p.codPessoa, pe.nome
ORDER BY numDisciplinas DESC;

/*
Questao 2
*/
SELECT 
    p.nome, 
    p.cpf, 
    a.matricula
FROM 
    Aluno a
JOIN 
    Pessoa p ON a.codPessoa = p.codPessoa
LEFT JOIN 
    DisciplinaAluno da ON a.codPessoa = da.codPessoaAluno AND da.ano = 2023
WHERE 
    da.codPessoaAluno IS NULL;

    /*
Questao 3
*/
CREATE VIEW ExemplaresNuncaEmprestados AS
SELECT e.tombo, e.tipo, l.titulo
FROM Exemplar e
JOIN Livro l ON e.codLivro = l.codLivro
LEFT JOIN Emprestimo emp ON e.codExemplar = emp.codExemplar
WHERE emp.codExemplar IS NULL
AND e.tipo = 'Empréstimo domiciliar';
  
  
/*
Questao 4
*/
SELECT A.matricula, P.nome
FROM Aluno A
INNER JOIN Pessoa P ON A.codPessoa = P.codPessoa
INNER JOIN DisciplinaAluno DA ON A.codPessoa = DA.codPessoaAluno
GROUP BY A.matricula, P.nome
HAVING AVG(DA.nota) >= 75;

/*
Questao 5
*/
DELIMITER $$

CREATE TRIGGER VerificaEmprestimoAntesDeInserir
BEFORE INSERT ON Emprestimo
FOR EACH ROW
BEGIN
    DECLARE exemplarEmprestado INT;

    
    SELECT COUNT(*)
    INTO exemplarEmprestado
    FROM Emprestimo
    WHERE codExemplar = NEW.codExemplar
    AND dataDevolucao IS NULL;

    IF exemplarEmprestado > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O exemplar já está emprestado e não foi devolvido.';
    END IF;
END $$

DELIMITER ;

/*
Questao 3
*/
CREATE VIEW ExemplaresNuncaEmprestados AS
SELECT e.tombo, e.tipo, l.titulo
FROM Exemplar e
JOIN Livro l ON e.codLivro = l.codLivro
LEFT JOIN Emprestimo emp ON e.codExemplar = emp.codExemplar
WHERE emp.codExemplar IS NULL
AND e.tipo = 'Empréstimo domiciliar';