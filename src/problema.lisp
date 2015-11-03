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

(defstruct problema estado-inicial solucao accoes resultado custo-caminho)

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
	(let ((lista-accoes nil) (n 10))
	(cond((equal  (first estado-pecas-por-colocar estado) 'i)
			(dotimes (i n)
				(cons (cria-accao (i peca-i0)) lista-accoes))
			(dotimes (i (- n 3))
				(cons (cria-accao (i peca-i1)) lista-accoes)))
		 ((equal (fist estado-pecas-por-colocar estado)'l)
			(dotimes (i (1- n))
				(cons (cria-accao (i peca-l0)) lista-accoes))
			(dotimes (i (- n 3))
				(cons (cria-accao (i peca-l1)) lista-accoes))
			(dotimes (i (1- n))
				(cons (cria-accao (i peca-l2)) lista-accoes))
			(dotimes (i (- n 3))
				(cons (cria-accao (i peca-l3)) lista-accoes)))
		 ((equal (frist estado-pecas-por-colocar estado) 'o)
			(dotimes (i (- n 2))
				(cons (cria-accao (i peca-o0)) lista-accoes)))
		 ((equal (first estado-pecas-por-colocar estado) 's)
			(dotimes (i (- n 3))
				(cons (cria-accao (i peca-s0)) lista-accoes))
			(dotimes (i (- n 2))
				(cons (cria-accao (i peca-s1)) lista-accoes)))
		 ((equal (first estado-pecas-por-colocar estado) 'z)
			(dotimes (i (- n 3))
				(cons (cria-accao (i peca-z0)) lista-accoes))
			(dotimes (i (- n 2))
				(cons (cria-accao (i peca-z1)) lista-accoes)))
		 (( equal (first estado-pecas-por-colocar estado) 't)
			(dotimes (i (- n 1))
				(cons (cria-accao (i peca-t0)) lista-accoes))
			(dotimes (i (- n 3))
				(cons (cria-accao (i peca-t1)) lista-accoes))
			(dotimes (i (- n 1))
				(cons (cria-accao (i peca-t2)) lista-accoes)))
    (lista-accoes))))

;; 	resultado: estado x accao -> estado
;;	Esta funcao recebe um estado e uma accao, e devolve um novo estado que resulta
;;  de aplicar a accao recebida no estado original.

(defun resultado (estado accao)
	(dotimes (altura-tabuleiro (array-dimension (estado-tabuleiro estado) 0))
    (if (verifica-espaco-livre (estado-tabuleiro estado) (cdr accao) (car accao) altura-tabuleiro)
      (progn (setf (estado-tabuleiro estado) (coloca-peca (estado-tabuleiro estado) (cdr accao) (car accao) altura-tabuleiro))
             (setf altura-tabuleiro (array-dimension (estado-tabuleiro estado) 0)))))
  (if T                                                                                             ;; verificar se o topo do tabuleiro esta preenchido
    (let ((linhas-completas 0)) 
      (dotimes (altura-tabuleiro (array-dimension (estado-tabuleiro estado) 0))
        (if NIL (incf linhas-completas)))                                                           ;; verificar se linha altura-tabuleiro do tabuleiro esta preenchida
      (cond
        ((= linhas-completas 1) (incf (estado-pontos estado) 100))
        ((= linhas-completas 2) (incf (estado-pontos estado) 300))
        ((= linhas-completas 3) (incf (estado-pontos estado) 500))
        ((= linhas-completas 4) (incf (estado-pontos estado) 800)))))
  estado)
                                     
(defun verifica-espaco-livre (tabuleiro peca x y)
  (dotimes (altura (array-dimension peca 0) T)
           (if (dotimes (largura (array-dimension peca 1) NIL)
                    (if (and (< (+ altura y) 18) 
                             (< (+ largura x) 10)
                             (aref tabuleiro (+ altura y) (+ largura x)))
                         (return T))) (return NIL))))

(defun coloca-peca (tabuleiro peca x y)
  (dotimes (altura-peca (array-dimension peca 0) tabuleiro)
           (dotimes (largura-peca (array-dimension peca 1))
                     (setf (aref tabuleiro (+ y altura-peca) (+ x largura-peca)) (aref peca altura-peca largura-peca)))))
		

;;	qualidade: estado -> inteiro
;;	Esta funcao recebe um estado e retorna um valor de quatidade que corresponde ao
;;valor negativo dos pontos ganhos ate ao momento.

(defun quantidade (estado)
	(* -1 (estado-pontos estado)))

;;	custo-oportunidade: estado -> inteiro
;;	Esta função, dado um estado, devolve o custo de oportunidade de todas as accoes
;;realizadas ate ao momento, assumindo que é sempre possivel fazer o maximo de pontos
;;por cada peca colocada

(defun custo-oportunidade (estado)
	(let (co (* 800 (list-length estado-pecas-colocadas estado))
	(decf co (estado-pontos estado))
	co)))

;;	custo-caminho: estado -> inteiro
;;	Esta função, dado um estado, devolve o custo de caminho desde o estado inicial
;;até ao estado inserido

(defun custo-caminho(estado)
	(let (cc (* 800 (list-length estado-pecas-colocadas problema-estado-inical)))
	(decf cc (estado-pontos estado))))
