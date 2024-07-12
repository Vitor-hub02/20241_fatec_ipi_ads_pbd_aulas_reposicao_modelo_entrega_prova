-- ----------------------------------------------------------------
-- 1 Base de dados e criação de tabela
--escreva a sua solução aqui
CREATE TABLE tb_performance_estudantes (
STUDENTID SERIAL PRIMARY KEY,
SALARY INT,
MOTHER_EDU INT,
FATHER_EDU INT,
PREP_STUDY INT,
PREP_EXAM INT,
GRADE INT
);

-- ----------------------------------------------------------------
-- 2 Resultado em função da formação dos pais
--escreva a sua solução aqui
 DO $$
 DECLARE
     cur_aprovados_phd CURSOR FOR
     SELECT COUNT(*)
     FROM tb_performance_estudantes
     WHERE GRADE >= 6 
     AND (MOTHER_EDU = 6 OR FATHER_EDU = 6); 
     num_aprovados INTEGER;
 BEGIN
     OPEN cur_aprovados_phd;
     FETCH cur_aprovados_phd INTO num_aprovados;
     RAISE NOTICE 'Número de alunos aprovados com pais PhD: %', num_aprovados;
     CLOSE cur_aprovados_phd;
 END;
 $$
-- ----------------------------------------------------------------
-- 3 Resultado em função dos estudos
--escreva a sua solução aqui
  DO $$
  DECLARE
    v_count INTEGER;
    v_query VARCHAR(200);

  BEGIN
    v_query := 'SELECT COUNT(*) FROM tb_performance_estudantes WHERE PREP_STUDY = 1 AND GRADE >= 60';

    EXECUTE v_query INTO v_count;

    IF v_count = 0 THEN
      v_count := -1;
   END IF;

   RAISE NOTICE 'Número de alunos aprovados que estudam sozinhos: %', v_count;
  END;
  $$

-- ----------------------------------------------------------------
-- 4 Salário versus estudos
--escreva a sua solução aqui
  DO $$
  DECLARE
    v_count INTEGER;
    v_query VARCHAR(200);

  BEGIN
    v_query := 'SELECT COUNT(*) FROM tb_performance_estudantes WHERE SALARY = 5 AND PREP_EXAM = 2';

    EXECUTE v_query INTO v_count;

    RAISE NOTICE 'Número de alunos com salário maior que 410 que se preparam regularmente para os exames: %', v_count;
  END;
 $$

-- ----------------------------------------------------------------
-- 5. Limpeza de valores NULL
--escreva a sua solução aqui
 DO $$
 DECLARE
    v_studentid INTEGER;
    v_salary INTEGER;
    v_mother_edu INTEGER;
    v_father_edu INTEGER;
    v_prep_study INTEGER;
    v_prep_exam INTEGER;
    v_grade INTEGER;

 BEGIN
     FOR cur IN SELECT * FROM tb_performance_estudantes LOOP
         IF cur.salary IS NULL OR cur.mother_edu IS NULL OR cur.father_edu IS NULL OR cur.prep_study IS NULL OR cur.prep_exam IS NULL OR cur.grade IS NULL THEN
             RAISE NOTICE 'Tupla a ser removida: %', cur;
             DELETE FROM tb_performance_estudantes WHERE studentid = cur.studentid;
        END IF;
     END LOOP;

     RAISE NOTICE 'Tuplas remanescentes:';
     FOR cur IN SELECT * FROM tb_performance_estudantes ORDER BY studentid DESC LOOP
         RAISE NOTICE '%', cur;
     END LOOP;
 END;
 $$
-- ----------------------------------------------------------------