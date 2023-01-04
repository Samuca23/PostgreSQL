CREATE TABLE mesas (
    id int not null primary key,
    mesa_codigo varchar(20),
    mesa_situacao varchar (1) default 'A',
    data_criacao timestamp,
    data_atualizacao timestamp
);

CREATE TABLE funcionarios(
    id int not null primary key,
    funcionario_codigo varchar(20),
    funcionario_nome varchar(100),
    funcionario_situacaio varchar(1) default 'A',
    funcionario_comissao real,
    data_criacao timestamp,
    data_atualizacao timestamp
);

CREATE TABLE vendas(
    id int not null primary key,
    funcionario_id int references funcionarios (id),
    mesa_id int references mesas (id),
    venda_codigo varchar(20),
    venda_valor real,
    venda_total real,
    venda_desconto real,
    data_criacao timestamp,
    data_atualizacao timestamp
);

CREATE TABLE produtos (
    id int not null primary key,
    produto_codigo varchar(20),
    produto_nome varchar(60),
    produto_valor real,
    produto_situacao varchar (1) default 'A',
    data_criacao timestamp,
    data_atualizacao timestamp
);

CREATE TABLE itens_vendas (
    id int not null primary key,
    produto_id int not null references produtos(id),
    vendas_id int not null references vendas(id),
    item_valor real,
    item_quantidade int,
    item_total real,
    data_criacao timestamp,
    data_atualizacao timestamp
);

DROP TABLE comissoes;

CREATE TABLE comissoes(
    id int not null,
    funcionario_id int,
    comissao_valor real,
    comissao_situacao varchar(1) default 'A',
    data_criacao timestamp,
    data_atualizacao timestamp
)
/* Adicionando a PK na tabela */
ALTER TABLE
    comissoes
ADD
    CONSTRAINT comissoes_pkey PRIMARY KEY(id);

/* Adicionando a FK na tabela */
ALTER TABLE
    comissoes
ADD
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id);

/* Verificando se o valor de venda total é positivo */
ALTER TABLE
    vendas
ADD
    CHECK (venda_total > 0)
    /* Verificando se o nome não é null*/
ALTER TABLE
    funcionarios
ADD
    CHECK (funcionario_nome <> null)
    /* Criando SEQUENCES para as tabelas */
    CREATE SEQUENCE mesa_id_seq;

CREATE SEQUENCE vendas_id_seq;

CREATE SEQUENCE itens_vendas_id_seq;

CREATE SEQUENCE produtos_id_seq;

CREATE SEQUENCE funcionario_id_seq;

CREATE SEQUENCE comissoes_id_seq;

/* Vinculando as SEQUENCES para suas respectivas tabelas */
ALTER TABLE
    mesas
ALTER COLUMN
    id
SET
    DEFAULT nextval('mesa_id_seq');

ALTER TABLE
    vendas
ALTER COLUMN
    id
SET
    DEFAULT nextval('vendas_id_seq');

ALTER TABLE
    ITENS_VENDAS
ALTER COLUMN
    id
SET
    DEFAULT nextval('itens_vendas_id_seq');

ALTER TABLE
    produtos
ALTER COLUMN
    id
SET
    DEFAULT nextval('produtos_id_seq');

ALTER TABLE
    funcionarios
ALTER COLUMN
    id
SET
    DEFAULT nextval('funcionario_id_seq');

ALTER TABLE
    comissoes
ALTER COLUMN
    id
SET
    DEFAULT nextval('comissoes_id_seq');

/* Para deletar uma SEQUENCE */
/* Utilizar o CASCADE caso ela faça relação com outra tabela */
DROP SEQUENCE funcionario_id_seq CASCADE;

/* Adicionando nova coluna na tabela */
ALTER TABLE
    comissoes
ADD
    COLUMN data_pagamento timestamp;

ALTER TABLE
    comissoes DROP COLUMN data_pagamento;

/* Inserindo novos dados as tabelas */
INSERT INTO
    mesas (
        mesa_codigo,
        mesa_situacao,
        data_criacao,
        data_atualizacao
    )
VALUES
    (
        '00010',
        'A',
        NOW(),
        NOW()
    );

INSERT INTO
    funcionarios (
        funcionario_codigo,
        funcionario_nome,
        funcionario_situacao,
        funcionario_comissao,
        funcionario_cargo,
        data_criacao,
        data_atualizacao
    )
VALUES
    (
        '00007',
        'Ana Paula Schimitt',
        'A',
        5,
        'QUALIDADE',
        NOW(),
        NOW()
    );

INSERT INTO
    produtos (
        produto_codigo,
        produto_nome,
        produto_valor,
        produto_situacao,
        data_criacao,
        data_atualizacao
    )
VALUES
    (
        '00006',
        'Web Cam',
        180,
        'A',
        NOW(),
        NOW()
    );

INSERT INTO
    vendas (
        funcionario_id,
        mesa_id,
        venda_codigo,
        venda_valor,
        venda_total,
        venda_desconto,
        venda_situacao,
        data_criacao,
        data_atualizacao
    )
VALUES
    (
        4,
        4,
        '00003',
        2000,
        2000,
        0,
        'A',
        NOW(),
        NOW()
    );

INSERT INTO
    itens_vendas (
        produto_id,
        vendas_id,
        item_valor,
        item_quantidade,
        item_total,
        data_criacao,
        data_atualizacao
    )
VALUES
    (
        3,
        3,
        7,
        3,
        21,
        NOW(),
        NOW()
    );

/* Criando FUNCTION para retornar a situação do funcionario */
CREATE
OR REPLACE FUNCTION retorna_nome_funcionario(fund_id int) RETURNS text AS $ $ DECLARE nome text;

situacao text;

BEGIN
SELECT
    funcionario_nome,
    funcionario_situacao INTO nome,
    situacao
FROM
    funcionarios
WHERE
    id = fund_id;

IF situacao = 'A' THEN RETURN nome || ' Usuário Ativo';

ELSEIF situacao = 'I' THEN RETURN nome || ' Usuário Inativo';

ELSEIF situacao IS NULL THEN RETURN nome || ' Usuário Sem status';

ELSE RETURN 'Usuário com status diferente de A e I';

END IF;

END $ $ LANGUAGE plpgsql;

DROP FUNCTION retorna_nome_funcionario;

SELECT
    retorna_nome_funcionario(1);

/* FUNCTION para calcular a porcentagem da comissao */
CREATE
OR REPLACE FUNCTION rt_valor_comissao(func_id int) RETURNS real AS $ $ DECLARE valor_comissao real;

BEGIN
SELECT
    funcionario_comissao INTO valor_comissao
FROM
    funcionarios
WHERE
    id = func_id;

RETURN valor_comissao;

END $ $ LANGUAGE plpgsql;

DROP FUNCTION rt_valor_comissao;

SELECT
    rt_valor_comissao(1);

CREATE TABLE mesas (
    id int not null primary key,
    mesa_codigo varchar(20),
    mesa_situacao varchar (1) default 'A',
    data_criacao timestamp,
    data_atualizacao timestamp
);

CREATE TABLE funcionarios(
    id int not null primary key,
    funcionario_codigo varchar(20),
    funcionario_nome varchar(100),
    funcionario_situacaio varchar(1) default 'A',
    funcionario_comissao real,
    data_criacao timestamp,
    data_atualizacao timestamp
);

CREATE TABLE vendas(
    id int not null primary key,
    funcionario_id int references funcionarios (id),
    mesa_id int references mesas (id),
    venda_codigo varchar(20),
    venda_valor real,
    venda_total real,
    venda_desconto real,
    data_criacao timestamp,
    data_atualizacao timestamp
);

CREATE TABLE produtos (
    id int not null primary key,
    produto_codigo varchar(20),
    produto_nome varchar(60),
    produto_valor real,
    produto_situacao varchar (1) default 'A',
    data_criacao timestamp,
    data_atualizacao timestamp
);

CREATE TABLE itens_vendas (
    id int not null primary key,
    produto_id int not null references produtos(id),
    vendas_id int not null references vendas(id),
    item_valor real,
    item_quantidade int,
    item_total real,
    data_criacao timestamp,
    data_atualizacao timestamp
);

DROP TABLE comissoes;

CREATE TABLE comissoes(
    id int not null,
    funcionario_id int,
    comissao_valor real,
    comissao_situacao varchar(1) default 'A',
    data_criacao timestamp,
    data_atualizacao timestamp
)
/* Adicionando a PK na tabela */
ALTER TABLE
    comissoes
ADD
    CONSTRAINT comissoes_pkey PRIMARY KEY(id);

/* Adicionando a FK na tabela */
ALTER TABLE
    comissoes
ADD
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id);

/* Verificando se o valor de venda total é positivo */
ALTER TABLE
    vendas
ADD
    CHECK (venda_total > 0)
    /* Verificando se o nome não é null*/
ALTER TABLE
    funcionarios
ADD
    CHECK (funcionario_nome <> null)
    /* Criando SEQUENCES para as tabelas */
    CREATE SEQUENCE mesa_id_seq;

CREATE SEQUENCE vendas_id_seq;

CREATE SEQUENCE itens_vendas_id_seq;

CREATE SEQUENCE produtos_id_seq;

CREATE SEQUENCE funcionario_id_seq;

CREATE SEQUENCE comissoes_id_seq;

/* Vinculando as SEQUENCES para suas respectivas tabelas */
ALTER TABLE
    mesas
ALTER COLUMN
    id
SET
    DEFAULT nextval('mesa_id_seq');

ALTER TABLE
    vendas
ALTER COLUMN
    id
SET
    DEFAULT nextval('vendas_id_seq');

ALTER TABLE
    ITENS_VENDAS
ALTER COLUMN
    id
SET
    DEFAULT nextval('itens_vendas_id_seq');

ALTER TABLE
    produtos
ALTER COLUMN
    id
SET
    DEFAULT nextval('produtos_id_seq');

ALTER TABLE
    funcionarios
ALTER COLUMN
    id
SET
    DEFAULT nextval('funcionario_id_seq');

ALTER TABLE
    comissoes
ALTER COLUMN
    id
SET
    DEFAULT nextval('comissoes_id_seq');

/* Para deletar uma SEQUENCE */
/* Utilizar o CASCADE caso ela faça relação com outra tabela */
DROP SEQUENCE funcionario_id_seq CASCADE;

/* Adicionando nova coluna na tabela */
ALTER TABLE
    comissoes
ADD
    COLUMN data_pagamento timestamp;

ALTER TABLE
    comissoes DROP COLUMN data_pagamento;

/* Inserindo novos dados as tabelas */
INSERT INTO
    mesas (
        mesa_codigo,
        mesa_situacao,
        data_criacao,
        data_atualizacao
    )
VALUES
    (
        '00010',
        'A',
        NOW(),
        NOW()
    );

INSERT INTO
    funcionarios (
        funcionario_codigo,
        funcionario_nome,
        funcionario_situacao,
        funcionario_comissao,
        funcionario_cargo,
        data_criacao,
        data_atualizacao
    )
VALUES
    (
        '00007',
        'Ana Paula Schimitt',
        'A',
        5,
        'QUALIDADE',
        NOW(),
        NOW()
    );

INSERT INTO
    produtos (
        produto_codigo,
        produto_nome,
        produto_valor,
        produto_situacao,
        data_criacao,
        data_atualizacao
    )
VALUES
    (
        '00006',
        'Web Cam',
        180,
        'A',
        NOW(),
        NOW()
    );

INSERT INTO
    vendas (
        funcionario_id,
        mesa_id,
        venda_codigo,
        venda_valor,
        venda_total,
        venda_desconto,
        venda_situacao,
        data_criacao,
        data_atualizacao
    )
VALUES
    (
        4,
        4,
        '00003',
        2000,
        2000,
        0,
        'A',
        NOW(),
        NOW()
    );

INSERT INTO
    itens_vendas (
        produto_id,
        vendas_id,
        item_valor,
        item_quantidade,
        item_total,
        data_criacao,
        data_atualizacao
    )
VALUES
    (
        3,
        3,
        7,
        3,
        21,
        NOW(),
        NOW()
    );

/* Criando FUNCTION para retornar a situação do funcionario */
CREATE
OR REPLACE FUNCTION retorna_nome_funcionario(fund_id int) RETURNS text AS $ $ DECLARE nome text;

situacao text;

BEGIN
SELECT
    funcionario_nome,
    funcionario_situacao INTO nome,
    situacao
FROM
    funcionarios
WHERE
    id = fund_id;

IF situacao = 'A' THEN RETURN nome || ' Usuário Ativo';

ELSEIF situacao = 'I' THEN RETURN nome || ' Usuário Inativo';

ELSEIF situacao IS NULL THEN RETURN nome || ' Usuário Sem status';

ELSE RETURN 'Usuário com status diferente de A e I';

END IF;

END $ $ LANGUAGE plpgsql;

DROP FUNCTION retorna_nome_funcionario;

SELECT
    retorna_nome_funcionario(1);

/* FUNCTION para calcular a porcentagem da comissao */
CREATE
OR REPLACE FUNCTION rt_valor_comissao(func_id int) RETURNS real AS $ $ DECLARE valor_comissao real;

BEGIN
SELECT
    funcionario_comissao INTO valor_comissao
FROM
    funcionarios
WHERE
    id = func_id;

RETURN valor_comissao;

END $ $ LANGUAGE plpgsql;

DROP FUNCTION rt_valor_comissao;

SELECT
    rt_valor_comissao(1);

CREATE TABLE mesas (
    id int not null primary key,
    mesa_codigo varchar(20),
    mesa_situacao varchar (1) default 'A',
    data_criacao timestamp,
    data_atualizacao timestamp
);

CREATE TABLE funcionarios(
    id int not null primary key,
    funcionario_codigo varchar(20),
    funcionario_nome varchar(100),
    funcionario_situacaio varchar(1) default 'A',
    funcionario_comissao real,
    data_criacao timestamp,
    data_atualizacao timestamp
);

CREATE TABLE vendas(
    id int not null primary key,
    funcionario_id int references funcionarios (id),
    mesa_id int references mesas (id),
    venda_codigo varchar(20),
    venda_valor real,
    venda_total real,
    venda_desconto real,
    data_criacao timestamp,
    data_atualizacao timestamp
);

CREATE TABLE produtos (
    id int not null primary key,
    produto_codigo varchar(20),
    produto_nome varchar(60),
    produto_valor real,
    produto_situacao varchar (1) default 'A',
    data_criacao timestamp,
    data_atualizacao timestamp
);

CREATE TABLE itens_vendas (
    id int not null primary key,
    produto_id int not null references produtos(id),
    vendas_id int not null references vendas(id),
    item_valor real,
    item_quantidade int,
    item_total real,
    data_criacao timestamp,
    data_atualizacao timestamp
);

DROP TABLE comissoes;

CREATE TABLE comissoes(
    id int not null,
    funcionario_id int,
    comissao_valor real,
    comissao_situacao varchar(1) default 'A',
    data_criacao timestamp,
    data_atualizacao timestamp
)
/* Adicionando a PK na tabela */
ALTER TABLE
    comissoes
ADD
    CONSTRAINT comissoes_pkey PRIMARY KEY(id);

/* Adicionando a FK na tabela */
ALTER TABLE
    comissoes
ADD
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id);

/* Verificando se o valor de venda total é positivo */
ALTER TABLE
    vendas
ADD
    CHECK (venda_total > 0)
    /* Verificando se o nome não é null*/
ALTER TABLE
    funcionarios
ADD
    CHECK (funcionario_nome <> null)
    /* Criando SEQUENCES para as tabelas */
    CREATE SEQUENCE mesa_id_seq;

CREATE SEQUENCE vendas_id_seq;

CREATE SEQUENCE itens_vendas_id_seq;

CREATE SEQUENCE produtos_id_seq;

CREATE SEQUENCE funcionario_id_seq;

CREATE SEQUENCE comissoes_id_seq;

/* Vinculando as SEQUENCES para suas respectivas tabelas */
ALTER TABLE
    mesas
ALTER COLUMN
    id
SET
    DEFAULT nextval('mesa_id_seq');

ALTER TABLE
    vendas
ALTER COLUMN
    id
SET
    DEFAULT nextval('vendas_id_seq');

ALTER TABLE
    ITENS_VENDAS
ALTER COLUMN
    id
SET
    DEFAULT nextval('itens_vendas_id_seq');

ALTER TABLE
    produtos
ALTER COLUMN
    id
SET
    DEFAULT nextval('produtos_id_seq');

ALTER TABLE
    funcionarios
ALTER COLUMN
    id
SET
    DEFAULT nextval('funcionario_id_seq');

ALTER TABLE
    comissoes
ALTER COLUMN
    id
SET
    DEFAULT nextval('comissoes_id_seq');

/* Para deletar uma SEQUENCE */
/* Utilizar o CASCADE caso ela faça relação com outra tabela */
DROP SEQUENCE funcionario_id_seq CASCADE;

/* Adicionando nova coluna na tabela */
ALTER TABLE
    comissoes
ADD
    COLUMN data_pagamento timestamp;

ALTER TABLE
    comissoes DROP COLUMN data_pagamento;

/* Inserindo novos dados as tabelas */
INSERT INTO
    mesas (
        mesa_codigo,
        mesa_situacao,
        data_criacao,
        data_atualizacao
    )
VALUES
    (
        '00010',
        'A',
        NOW(),
        NOW()
    );

INSERT INTO
    funcionarios (
        funcionario_codigo,
        funcionario_nome,
        funcionario_situacao,
        funcionario_comissao,
        funcionario_cargo,
        data_criacao,
        data_atualizacao
    )
VALUES
    (
        '00007',
        'Ana Paula Schimitt',
        'A',
        5,
        'QUALIDADE',
        NOW(),
        NOW()
    );

INSERT INTO
    produtos (
        produto_codigo,
        produto_nome,
        produto_valor,
        produto_situacao,
        data_criacao,
        data_atualizacao
    )
VALUES
    (
        '00006',
        'Web Cam',
        180,
        'A',
        NOW(),
        NOW()
    );

INSERT INTO
    vendas (
        funcionario_id,
        mesa_id,
        venda_codigo,
        venda_valor,
        venda_total,
        venda_desconto,
        venda_situacao,
        data_criacao,
        data_atualizacao
    )
VALUES
    (
        4,
        4,
        '00003',
        2000,
        2000,
        0,
        'A',
        NOW(),
        NOW()
    );

INSERT INTO
    itens_vendas (
        produto_id,
        vendas_id,
        item_valor,
        item_quantidade,
        item_total,
        data_criacao,
        data_atualizacao
    )
VALUES
    (
        3,
        3,
        7,
        3,
        21,
        NOW(),
        NOW()
    );

/* Criando FUNCTION para retornar a situação do funcionario */
CREATE
OR REPLACE FUNCTION retorna_nome_funcionario(fund_id int) RETURNS text AS $ $ DECLARE nome text;

situacao text;

BEGIN
SELECT
    funcionario_nome,
    funcionario_situacao INTO nome,
    situacao
FROM
    funcionarios
WHERE
    id = fund_id;

IF situacao = 'A' THEN RETURN nome || ' Usuário Ativo';

ELSEIF situacao = 'I' THEN RETURN nome || ' Usuário Inativo';

ELSEIF situacao IS NULL THEN RETURN nome || ' Usuário Sem status';

ELSE RETURN 'Usuário com status diferente de A e I';

END IF;

END $ $ LANGUAGE plpgsql;

DROP FUNCTION retorna_nome_funcionario;

SELECT
    retorna_nome_funcionario(1);

/* FUNCTION para calcular a porcentagem da comissao */
CREATE
OR REPLACE FUNCTION rt_valor_comissao(func_id int) RETURNS real AS $ $ DECLARE valor_comissao real;

BEGIN
SELECT
    funcionario_comissao INTO valor_comissao
FROM
    funcionarios
WHERE
    id = func_id;

RETURN valor_comissao;

END $ $ LANGUAGE plpgsql;

DROP FUNCTION rt_valor_comissao;

SELECT
    rt_valor_comissao(1);

/* FUNCTION sem retorno para que faça o calculo das vendas que tenham comissões */
CREATE
OR REPLACE FUNCTION calc_comissao(data_ini timestamp, data_fim timestamp) RETURNS void AS $ $ DECLARE --	declaração das variáveis que vamos
--	utilizar. Já nadeclaração elas
--	recebem	o valor zero. Pois assim
--	garanto	que	elas estarão zeradas
--	quando for utilizá-las.
total_comissao real := 0;

porce_comissao real := 0;

--	declarando uma variável para armazenar	
--	os registros dos loops
reg record;

--cursor para buscar a % de comissão do	funcionário
cr_porce CURSOR (func_id int) IS
SELECT
    rt_valor_comissao(func_id);

BEGIN --	realiza	um loop	e busca todas as vendas
--	no período informado
FOR reg IN(
    SELECT
        vendas.id id,
        funcionario_id,
        venda_total
    FROM
        vendas
    WHERE
        data_criacao >= data_ini
        AND data_criacao <= data_fim
        AND venda_situacao = 'A'
) LOOP -- abertura, utilização e fechamento	do cursor
OPEN cr_porce(reg.funcionario_id);

FETCH cr_porce INTO porce_comissao;

CLOSE cr_porce;

total_comissao := (reg.venda_total * porce_comissao) / 100;

-- insere na tabela	de comissões o valor	
-- que o funcionário irá receber de	comissão
-- daquela venda
INSERT INTO
    comissoes(
        funcionario_id,
        comissao_valor,
        comissao_situacao,
        data_criacao,
        data_atualizacao
    )
VALUES
(
        reg.funcionario_id,
        total_comissao,
        'A',
        NOW(),
        NOW()
    );

-- update na	situação da	venda	
-- para que	ela	não	seja mais comissionada
UPDATE
    vendas
SET
    venda_situacao = 'C'
WHERE
    id = reg.id;

-- devemos zerar	as variáveis para reutilizá-las
total_comissao := 0;

porce_comissao := 0;

-- término do loop
END LOOP;

END $ $ LANGUAGE plpgsql;

SELECT
    calc_comissao('01/01/2016 00:00:00', '01/01/2016 00:00:00');