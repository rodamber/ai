;; TIPO PROBLEMA

;; Estrutura do problema do jogo
;; - estado-inicial: contem o estado inicial do problema de procura;
;; - solucao: função que recebe um estado e devolve T se o estado
;;     for uma solucao para o problema de procura, e nil caso contrario;
;; - accoes: função que recebe um estado e devolve uma lista com todas
;;	   as accoes que são possiveis fazer nesse estado;
;; - resultado: função que dado um estado e uma accao devolve o estado 
;;     sucessor que resulta de executar a accao recebida no estado recebido;
;; - custo-caminho: funcao que dado um estado devolve o custo do caminho
;;     desde o estado inicial até esse estado.

(defstruct problema estado-inicial solucao(estado) accoes(estado) resultado(estado accao) custo-caminho(estado))

;;	solucao: estado -> logico
;;	Esta função recebe um estado, e devolve o valor logico verdade se o estado
;;recebido corresponder a uma solucao, e falso contrario. Um estado do jogo
;;Tetris é considerado solucao se o topo do tabuleiro nao estiver preenchido e
;;se ja nao existem peças por colocar, ou seja, todas as peças foram colocadas
;;com sucesso.

(defun solucao (estado)
  (estado-final-p (estado)))

;;	accoes: estado -> lista de accoes
;;	Esta funcao recebe um estado e devolve uma lista de acções correspondendo a
;;todas as accoes validas que podem ser feitas com a proxima peça a ser colocada.
;;Uma acção e considerada valida mesmo que faça o jogador perder o jogo.

(defun accoes (estado)
	(let ((lista-accoes nil))
	(let ((n 9))
	(cond((and (car (estado-pecas-por-colocar estado) )(= 'i))
		(dotimes (i n)
			(push (cria-accao (i peca-i0)) lista-accoes))
		(dotimes (i n-3)
			(push (cria-accao (i peca-i1)) lista-accoes))))
	(cond((and (car (estado-pecas-por-colocar estado) )(= 'l))
		(dotimes (i n-1)
			(push (cria-accao (i peca-l0)) lista-accoes))
		(dotimes (i n-3)
			(push (cria-accao (i peca-l1)) lista-accoes))
		(dotimes (i n-1)
			(push (cria-accao (i peca-l2)) lista-accoes))
		(dotimes (i n-3)
			(push (cria-accao (i peca-l3)) lista-accoes))))
	(cond((and (car (estado-pecas-por-colocar estado) )(= 'o))
		(dotimes (i n-2)
			(push (cria-accao (i peca-o0)) lista-accoes))))
	(cond((and (car (estado-pecas-por-colocar estado) )(= 's))
		(dotimes (i n-3)
			(push (cria-accao (i peca-s0)) lista-accoes))
		(dotimes (i n-2)
			(push (cria-accao (i peca-s1)) lista-accoes))))
	(cond((and (car (estado-pecas-por-colocar estado) )(= 'z))
		(dotimes (i n-3)
			(push (cria-accao (i peca-z0)) lista-accoes))
		(dotimes (i n-2)
			(push (cria-accao (i peca-z1)) lista-accoes))))
	(cond((and (car (estado-pecas-por-colocar estado) )(= 't))
		(dotimes (i n-1)
			(push (cria-accao (i peca-t0)) lista-accoes))
		(dotimes (i n-3)
			(push (cria-accao (i peca-t1)) lista-accoes))
		(dotimes (i n-1)
			(push (cria-accao (i peca-t2)) lista-accoes))))
    lista-accoes)))

;; 	resultado: estado x accao -> estado
;;	Esta funcao recebe um estado e uma accao, e devolve um novo estado que resulta
;;de aplicar a accao recebida no estado original.

(defun resultado (estado accao)
	(let ((n 17))
	(let((count 0))
	(let ((estado1 copia-estado (estado))
	(desenha-estado(estado1 accao))
	(cons(car (estado-pecas-por-colocar estado1) )(estado-pecas-colocadas estado1))
	((estado-pecas-por-colocar estado1)(cdr(estado-pecas-por-colocar estado1)))
	(cond(estado-final-p (estado1))
		estado1)
	(cond(and ((estado-final-p (estado1))(= nil)))
		(dotimes (i n)
			(cond(tabuleiro-linha-completa-p(estado-tabuleiro estado1))
				tabuleiro-remove-linha(estado-tabuleiro estado1 n)
				(+ 1 count)))
		(cond(eq (count 1))
			(+ 100 estado-pontos estado1))
		(cond(eq (count 2))
			(+ 300 estado-pontos estado1))
		(cond(eq (count 3))
			(+ 500 estado-pontos estado1))
		(cond(eq (count 4))
			(+ 800 estado-pontos estado1))
		estado1)
)))

;;	qualidade: estado -> inteiro
;;	Esta funcao recebe um estado e retorna um valor de qualidade que corresponde ao
;;valor negativo dos pontos ganhos ate ao momento.

(defun quantidade (estado)

)

;;	custo-oportunidade: estado -> inteiro
;;	Esta função, dado um estado, devolve o custo de oportunidade de todas as accoes
;;realizadas ate ao momento, assumindo que é sempre possivel fazer o maximo de pontos
;;por cada peca colocada

(defun custo-oportunidade (estado)

)