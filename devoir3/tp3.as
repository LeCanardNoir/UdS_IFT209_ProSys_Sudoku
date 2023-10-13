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

		mov		x19, #0
LireSudoku_LoopCheck:
		cmp		x19, #81
		b.ge	LireSudoku_LoopEnd
		add		x19, x19, #1		//Incrémente l'index

		mov		x20, x0				//On met l'adresse du sudoku dans x20
		adr		x21, buffer			//On met l'adresse du buffer dans x21

		adr		x0, scfmt1
		mov		x1, x21
		bl		scanf
		ldr		w22, [x21]			//On met la valeur lue dans x22
        strb	w22, [x20], #1		//On le met dans le sudoku et on déplace l'adresse du sudoku au prochain
LireSudoku_LoopEnd:



		RESTORE
        ret


AfficherSudoku:
        SAVE
		mov		x20, x0				//On met l'adresse de Sudoku dans x20
		adr		x0, ptfmt1
		bl		printf				//On affiche une ligne horizontale

AfficherSudoku_loopInit:
		mov		x19, #0				//On met dans x19 l'index
		mov		x28, #0				//L'index pour les lignes horizontale (chaque modulo 27)
		mov		x27, #0				//L'index pour changer de ligne (chaque modulo 9)
		mov		x26, #0				//L'index pour les barres verticales (chaque modulo 3)
AfficherSudoku_LoopCheck:
		cmp		x19, #81			//Si l'index est plus petit que 81, on continue, sinon, STOP
		b.ge	AfficherSudoku_loopEnd
AfficherSudoku_LoopContent:
		cmp		x28, #27
		csel	x28, xzr, x28, ge
		cmp		x28, #0
		b.eq	AfficherSudoku_SkipLigneHorizontale
		adr		x0, ptfmt1
		bl		printf

AfficherSudoku_SkipLigneHorizontale:
		cmp		x26, #3
		csel	x26, xzr, x26, ge
		cmp		x26, #0
		b.eq	AfficherSudoku_SkipBarreVerticale
		adr		x0, ptfmt3
		bl		printf

AfficherSudoku_SkipBarreVerticale:
		adr		x0, ptfmt2
		adr		x1, [x20], #1
		bl		printf

		cmp		x27, #9
		csel	x27, xzr, x27, ge
		cmp		x27, #0
		b.eq	AfficherSudoku_SkipNouvelleLigne
		adr		x0, ptfmt4
		bl		printf

AfficherSudoku_SkipNouvelleLigne:
		add		x28, x28, #1
		add		x27, x27, #1
		add		x26, x26, #1
		add		x19, x19, #1		//Incrémente l'index
		b.al	AfficherSudoku_LoopCheck

AfficherSudoku_loopEnd:

        RESTORE
		ret


VerifierSudoku:
        SAVE
		mov		x20, x0				//x20 contient l'adresse du sudoku

VerifierSudoku_Rangees:
		//TODO Vérifier les rangées

VerifierSudoku_Rangees_OuterLoop:
		




VerifierSudoku_Colonnes:
		//TODO Vérifier les colonnes


VerifierSudoku_Blocs:
		//TODO Vérifier les blocs























        RESTORE
		ret

/*
	Remplit une array avec la valeur 0 dans chaque byte
	Entrées:
		x0: Adresse de l'array
		x1: Taille de l'array (en byte)
	Sorties:
		x0: Adresse de l'array
*/
ViderArray:
		mov		x2, #0				//x2 contient l'index
ViderArray_LoopCheck:
		cmp		x2, x1				//Si x2 < x1, continue
		b.lt	ViderArray_LoopContent
		b.al	ViderArray_LoopEnd
ViderArray_LoopContent:
		strb	wzr, [x0, x2]
		add		x2, x2, #1			//index++
		b.al	ViderArray_LoopCheck
ViderArray_LoopEnd:
		ret


/*
	Vérifie si l'array contient au moins une valeur 0, en ignorant l'index 0
	Entrées:
		x0: Adresse de l'array
		x1: Taille de l'array (en byte)
	Sorties:
		x0: Adresse de l'array
		x1: index qui a la valeur 0
*/
VerifierArray:
		mov		x2, #1				//x2 contient l'index
VerifierArray_LoopCheck:
		cmp		x2, x1				//si index < taille, on continue
		b.lt	VerifierArray_LoopContent
		b.al	VerifierArray_LoopEnd
VerifierArray_LoopContent:
		ldr		w3, [x0, x2]
		cbz		x3, VerifierArray_LoopEnd	//Si la valeur à l'index est 0, on sort de la boucle

		add		x2, x2, #1
		b.al	VerifierArray_LoopCheck
VerifierArray_LoopEnd:
		mov		x1, x2				//On met dans x1 l'index
		ret


.section ".rodata"

scfmt1:     .asciz  "%d"
ptfmt1:     .asciz	"|-------|-------|-------|\n"
ptfmt2:		.asciz	"%d "
ptfmt3:		.asciz	"| "
ptfmt4:		.asciz	"|\n"

.section ".bss"

buffer: .skip 4
Sudoku: .skip 81
