--11------------------------------------------------------------------------------------------------------------------------------------------------------------------- 레코드
/**
 PL/SQL 에서 제공하는 데이터 타입 중 하나로, 문자형, 숫자형 같은 기본 타입과 달리 복합형 구조이다
 일반 변수는 한 번에 하나의 값만 가질 수 있지만 
 레코드는 여러 개의 값을 가질 수 있다. 
 
 테이블과 흡사하며, 여러 개의 컬럼을 각기 다른 테이터 타입으로 선언해서 사용할 수 있다 (하지만 로우는 1개) 1개이상을 쓰려면 컬렉션사용. 
*/
DECLARE
  -- 부서레코드 타입선언
   TYPE depart_rect IS RECORD (
         department_id     NUMBER(6),
         department_name   VARCHAR2(80),
         parent_id         NUMBER(6),
         manager_id        NUMBER(6)   
   );
   
  -- 위에서 선언된 타입으로 레코드 변수 선언  
   vr_dep depart_rect;

BEGIN
 ...
END;


DECLARE
  -- 부서레코드 타입선언
   TYPE depart_rect IS RECORD (
         department_id     departments.department_id%TYPE,
         department_name  departments.department_name%TYPE, 
         parent_id          departments.parent_id%TYPE,
         manager_id        departments.manager_id%TYPE
   );
   
  -- 위에서 선언된 타입으로 레코드 변수 선언  
   vr_dep depart_rect;
BEGIN
-- …
END;


--12
----------------------------------------------------------------------------------------------------------------
DECLARE
  -- 부서레코드 타입선언
   TYPE depart_rect IS RECORD (
         department_id     departments.department_id%TYPE,
         department_name  departments.department_name%TYPE, 
         parent_id          departments.parent_id%TYPE,
         manager_id        departments.manager_id%TYPE
   );
   
  -- 위에서 선언된 타입으로 레코드 변수 선언  
   vr_dep depart_rect;
  -- 두 번째 변수 선언 
   vr_dep2 depart_rect;
BEGIN

   vr_dep.department_id := 999;
   vr_dep.department_name := '테스트부서';
   vr_dep.parent_id := 100;
   vr_dep.manager_id := NULL;
   
   -- 두 번째 변수에 첫 번째 레코드변수 대입
   vr_dep2 := vr_dep;
   
   DBMS_OUTPUT.PUT_LINE( 'vr_dep2.department_id :' || vr_dep2.department_id);
   DBMS_OUTPUT.PUT_LINE( 'vr_dep2.department_name :' ||  vr_dep2.department_name);
   DBMS_OUTPUT.PUT_LINE( 'vr_dep2.parent_id :' ||  vr_dep2.parent_id);
   DBMS_OUTPUT.PUT_LINE( 'vr_dep2.manager_id :' ||  vr_dep2.manager_id);
END;

--13
----------------------------------------------------------------------------------------------------------------
DECLARE
  -- 부서레코드 타입선언
   TYPE depart_rect IS RECORD (
         department_id     departments.department_id%TYPE,
         department_name  departments.department_name%TYPE, 
         parent_id          departments.parent_id%TYPE,
         manager_id        departments.manager_id%TYPE
   );
  -- 위에서 선언된 타입으로 레코드 변수 선언  
   vr_dep depart_rect;
  -- 두 번째 변수 선언 
   vr_dep2 depart_rect;
BEGIN
   vr_dep.department_id := 999;
   vr_dep.department_name := '테스트부서';
   vr_dep.parent_id := 100;
   vr_dep.manager_id := NULL;
   -- 두 번째 변수의 department_name에만 할당 
   vr_dep2.department_name := vr_dep.department_name;
   
   DBMS_OUTPUT.PUT_LINE( 'vr_dep2.department_id :' || vr_dep2.department_id);
   DBMS_OUTPUT.PUT_LINE( 'vr_dep2.department_name :' ||  vr_dep2.department_name);
   DBMS_OUTPUT.PUT_LINE( 'vr_dep2.parent_id :' ||  vr_dep2.parent_id);
   DBMS_OUTPUT.PUT_LINE( 'vr_dep2.manager_id :' ||  vr_dep2.manager_id);
END;

--14
----------------------------------------------------------------------------------------------------------------
CREATE TABLE ch11_dep AS
SELECT department_id, department_name, parent_id, manager_id
  FROM DEPARTMENTS ;
  
TRUNCATE TABLE   ch11_dep;
  
 DECLARE
  -- 부서레코드 타입선언
   TYPE depart_rect IS RECORD (
         department_id     departments.department_id%TYPE,
         department_name  departments.department_name%TYPE, 
         parent_id          departments.parent_id%TYPE,
         manager_id        departments.manager_id%TYPE
   );
   
  -- 위에서 선언된 타입으로 레코드 변수 선언  
   vr_dep depart_rect;

BEGIN

   vr_dep.department_id := 999;
   vr_dep.department_name := '테스트부서';
   vr_dep.parent_id := 100;
   vr_dep.manager_id := NULL;
   
   -- 레코드 필드를 명시해서 INSERT
   INSERT INTO ch11_dep VALUES ( vr_dep.department_id, vr_dep.department_name, vr_dep.parent_id, vr_dep.manager_id);
   
   -- 레코드 필드 순서와 개수, 타입이 같다면 레코드변수명으로만 INSERT 가능
   INSERT INTO ch11_dep VALUES vr_dep;
   COMMIT;
END;
--15
----------------------------------------------------------------------------------------------------------------
CREATE TABLE ch11_dep2 AS
SELECT *
  FROM DEPARTMENTS;

TRUNCATE TABLE   ch11_dep2;



-- 테이블형 레코드 
DECLARE
  -- 테이블형 레코드 변수 선언 
   vr_dep departments%ROWTYPE;

BEGIN
   -- 부서 테이블의 모든 정보를 레코드 변수에 넣는다. 
   SELECT *
     INTO vr_dep
     FROM departments
    WHERE department_id = 20;
   -- 레코드 변수를 이용해 ch11_dep2 테이블에 데이터를 넣는다. 
   INSERT INTO ch11_dep2 VALUES vr_dep;
   COMMIT;
END;

--16
----------------------------------------------------------------------------------------------------------------
-- 커서형 레코드 
DECLARE
  -- 커서 선언
   CURSOR c1 IS
       SELECT department_id, department_name, parent_id, manager_id
         FROM departments;       
   -- 커서형 레코드변수 선언  
   vr_dep c1%ROWTYPE;
BEGIN
   -- 데이터 삭제 
   DELETE ch11_dep;
   -- 커서 오픈 
   OPEN c1;
   -- 루프를 돌며 vr_dep 레코드 변수에 값을 넣고, 다시 ch11_dep에 INSERT
   LOOP
     FETCH c1 
     INTO vr_dep;
     EXIT WHEN c1%NOTFOUND;
     -- 레코드 변수를 이용해 ch11_dep2 테이블에 데이터를 넣는다. 
     INSERT INTO ch11_dep VALUES vr_dep;
   END LOOP;
   COMMIT;
END;

--17
----------------------------------------------------------------------------------------------------------------
DECLARE
   -- 레코드 변수 선언 
   vr_dep ch11_dep%ROWTYPE;

BEGIN
 
   vr_dep.department_id := 20;
   vr_dep.department_name := '테스트';
   vr_dep.parent_id := 10;
   vr_dep.manager_id := 200;
     
   -- ROW를 사용하면 해당 로우 전체가 갱신됨
     UPDATE ch11_dep
          SET ROW = vr_dep
      WHERE department_id = vr_dep.department_id; 
   
   COMMIT;
END;


-- 중첩 레코드
--18
----------------------------------------------------------------------------------------------------------------
DECLARE
  -- 부서번호, 부서명을 필드로 가진 dep_rec 레코드 타입 선언 
  TYPE dep_rec IS RECORD (
        dep_id      departments.department_id%TYPE,
        dep_name departments.department_name%TYPE );
        
  --사번, 사원명 그리고 dep_rec(부서번호, 부서명) 타입의 레코드 선언 
  TYPE emp_rec IS RECORD (
        emp_id      employees.employee_id%TYPE,
        emp_name employees.emp_name%TYPE,
        dep          dep_rec                          );
        
   --  emp_rec 타입의 레코드 변수 선언 
   vr_emp_rec emp_rec;
BEGIN
   -- 100번 사원의 사번, 사원명, 부서번호, 부서명을 가져온다. 
   SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
     INTO vr_emp_rec.emp_id, vr_emp_rec.emp_name, vr_emp_rec.dep.dep_id, vr_emp_rec.dep.dep_name
     FROM employees a, 
             departments b
    WHERE a.employee_id = 100
       AND a.department_id = b.department_id;
       
    -- 레코드 변수 값 출력    
    DBMS_OUTPUT.PUT_LINE('emp_id : ' ||  vr_emp_rec.emp_id);
    DBMS_OUTPUT.PUT_LINE('emp_name : ' ||  vr_emp_rec.emp_name);
    DBMS_OUTPUT.PUT_LINE('dep_id : ' ||  vr_emp_rec.dep.dep_id);
    DBMS_OUTPUT.PUT_LINE('dep_name : ' ||  vr_emp_rec.dep.dep_name);
END;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------- 레코드 끝