
# 📘 Projeto: Consultas SQL - Sistema Educacional e Biblioteca

Este repositório contém consultas SQL aplicadas a um sistema acadêmico que envolve professores, alunos, disciplinas e empréstimos de livros. As queries exploram operações com `JOIN`, `LEFT JOIN`, `GROUP BY`, `HAVING`, `VIEW` e funções de agregação.

---

## 📌 Enunciados e Respostas

### 📄 Questão 1
**Enunciado:**  
Liste os professores com a quantidade de disciplinas que cada um ministra, ordenando pelo número de disciplinas em ordem decrescente. Mostre o nome do professor e o número da carteira.

**Resposta:**
```sql
SELECT pe.nome AS nomeProfessor, 
       COUNT(d.codDisciplina) AS numDisciplinas,
       p.numCarteira
FROM Professor p
LEFT JOIN Pessoa pe ON p.codPessoa = pe.codPessoa
LEFT JOIN Disciplina d ON p.codPessoa = d.codPessoaProfessor
GROUP BY p.codPessoa, pe.nome
ORDER BY numDisciplinas DESC;
```

---

### 📄 Questão 2
**Enunciado:**  
Liste os alunos que não se matricularam em nenhuma disciplina no ano de 2023. Mostre nome, CPF e matrícula.

**Resposta:**
```sql
SELECT 
    p.nome, 
    p.cpf, 
    a.matricula
FROM Aluno a
JOIN Pessoa p ON a.codPessoa = p.codPessoa
LEFT JOIN DisciplinaAluno da ON a.codPessoa = da.codPessoaAluno AND da.ano = 2023
WHERE da.codPessoaAluno IS NULL;
```

---

### 📄 Questão 3
**Enunciado:**  
Crie uma view chamada `ExemplaresNuncaEmprestados` que liste os exemplares de livros do tipo "Empréstimo domiciliar" que nunca foram emprestados. Mostre o tombo, o tipo e o título do livro.

**Resposta:**
```sql
CREATE VIEW ExemplaresNuncaEmprestados AS
SELECT e.tombo, e.tipo, l.titulo
FROM Exemplar e
JOIN Livro l ON e.codLivro = l.codLivro
LEFT JOIN Emprestimo emp ON e.codExemplar = emp.codExemplar
WHERE emp.codExemplar IS NULL
  AND e.tipo = 'Empréstimo domiciliar';
```

---

### 📄 Questão 4
**Enunciado:**  
Liste os alunos com média de notas maior ou igual a 75 em todas as disciplinas. Mostre matrícula e nome do aluno.

**Resposta:**
```sql
SELECT A.matricula, P.nome
FROM Aluno A
INNER JOIN Pessoa P ON A.codPessoa = P.codPessoa
INNER JOIN DisciplinaAluno DA ON A.codPessoa = DA.codPessoaAluno
GROUP BY A.matricula, P.nome
HAVING AVG(DA.nota) >= 75;
```

---

### 📄 Questão 5
**Enunciado:**  
Crie um gatilho que impeça o empréstimo de um exemplar que já está emprestado e ainda não foi devolvido. Caso haja tentativa de inserção, o sistema deve emitir uma mensagem de erro.

**Resposta:**
```sql
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
```
