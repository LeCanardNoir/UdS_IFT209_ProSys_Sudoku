/********************************************************************************
*																				*
*	Programme qui lit, affiche et vérifie un sudoku.                          	*
*																				*
*															                    *
*	Auteurs: 																	*
*																				*
********************************************************************************/




.include "/root/SOURCES/ift209/tools/ift209.as"



.global Main


.section ".text"

/* Début du programme */

Main:	adr		x20,Sudoku          //x20 contient l'adresse de base du sudoku

        mov		x0,x20              //Paramètre: adresse du sudoku
        bl      LireSudoku			//Appelle le sous-programme de lecture

		mov		x0,x20				//Paramètre: adresse du sudoku
		bl		AfficherSudoku		//Appelle le sous-programme d'affichage

		mov		x0,x20				//Paramètre: adresse du sudoku
		bl		VerifierSudoku		//Appelle le sous-programme de vérification

		mov		  x0,#0				//0: tous les tampons
		bl        fflush			//Vidange des tampons

		mov		  x0,#0				//0: aucune erreur
		bl        exit				//Fin du programme




LireSudoku:
        SAVE

		mov		x19, #0				//Initialisation de la loop
		mov		x20, x0				//On met l'adresse du sudoku dans x20
		//add 	x20, x20, #1
		adr		x21, buffer			//On met l'adresse du buffer dans x21
LireSudoku_LoopCheck:
		cmp		x19, #81			//Check loop limit
		b.ge	LireSudoku_LoopEnd
		

		adr		x0, scfmt1
		add		x1, x20, x19      // x21
		bl		scanf
		ldr		w22, [x20, x19]			//On met la valeur lue dans x22
        //strb	w22, [x20]		//On le met dans le sudoku et on déplace l'adresse du sudoku au prochain
		//add   	x20, x20, #1
		add		x19, x19, #1		//Incrémente l'index
		b.al	LireSudoku_LoopCheck
LireSudoku_LoopEnd:


		RESTORE
        ret


AfficherSudoku:
        SAVE
		mov		x20, x0
		mov		x19, #0
		mov		x21, #3

AfficherSudoku_line:
		cmp		x21, #3
		b.lt	AfficherSudoku_Loop
		adr		x0, ptfmt1
		ldr		x1, [x0]
		bl		printf
		mov		x21, #0
		
AfficherSudoku_Loop:
		cmp		x19, #9
		b.ge	AfficherSudoku_LoopEnd

		adr		x0, ptfmt2
		ldrb	w1, [x20], #1
		ldrb	w2, [x20], #1
		ldrb	w3, [x20], #1
		bl		printf

		adr	x0, ptfmt2
		ldrb	w1, [x20], #1
		ldrb	w2, [x20], #1
		ldrb	w3, [x20], #1
		bl		printf

		adr		x0, ptfmt3
		ldrb	w1, [x20], #1
		ldrb	w2, [x20], #1
		ldrb	w3, [x20], #1
		bl		printf

		add		x21, x21, #1
		add		x19, x19, #1
		b.al	AfficherSudoku_line

AfficherSudoku_LoopEnd:


        RESTORE
		ret


VerifierSudoku:
        SAVE




        RESTORE
		ret


.section ".rodata"

scfmt1:     .asciz  "%d"
ptfmt2:     .asciz	"| %d %d %d "
ptfmt3:     .asciz	"| %d %d %d |\n"
//ptfmt3:     .asciz  "Sudoku: %d\n"

.section ".bss"

		.align 1
buffer: .skip 4
Sudoku: .skip 81

.section ".data"

ptfmt1:     .asciz	"|-------|-------|-------|\n"
