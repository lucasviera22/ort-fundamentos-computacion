{-#LANGUAGE GADTs #-}
{-# OPTIONS_GHC -fno-warn-tabs #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant lambda" #-}
{-# HLINT ignore "Use lambda-case" #-}

module FS where 

import Prelude

-- Nombre: Lucas Viera
-- Número: 177863

type Nombre = String 

data Ext where { Txt::Ext ; Mp3::Ext ; Jar::Ext ; Doc::Ext ; Hs::Ext }
  deriving (Eq)

instance Show Ext where 
	show = \ex -> case ex of{ Txt-> "txt" ; 
					     	 Mp3-> "mp3" ; 
						     Jar-> "jar" ; 
						     Doc-> "doc" ; 
						     Hs-> "hs"}

data FS where {  A :: (Nombre,Ext) -> FS;
                 C :: Nombre -> [FS] -> FS }
  deriving (Eq, Show)

----
-- 1
cjazz :: FS 
cjazz = C "jazz" [A ("mumbles", Mp3)]

crock :: FS 
crock = C "rock" [ A ("clones", Mp3), A ("bajan", Mp3), A ("clara", Mp3)]

cmusica :: FS
cmusica = C "musica" [cjazz, crock, A ("clara", Mp3)]


-- Completar el resto de los componentes del FS

cort :: FS
cort = C "ort" [cobls, A ("notas", Txt)] 

cobls :: FS
cobls = C "obls" [A ("p2", Txt), A ("p2", Jar), A ("fc", Hs)]

csys :: FS
csys = C "sys" [A ("sys", Txt), C "sys" []]

csysvacio :: FS
csysvacio = C "sys" []

craiz :: FS
craiz = C "raiz" [cmusica, A ("notas", Txt), cort, csys]

----
-- 2
nombre :: FS -> Nombre
nombre = \fs -> case fs of { A (n, e) -> n ++ "." ++ show e;
                             C nom fss ->  nom }
----
-- 3
contenido :: FS -> [Nombre]
contenido = \fs -> case fs of { A (n, e) -> error "no es carpeta";
	                            C n fss -> case fss of {[] -> [];		
														x:xs -> [nombre x] ++ contenido (C "" xs) }}
----
-- 4
cantA :: FS -> Int 
cantA = \fs -> case fs of { A (n, e) -> 1;
	                        C n fss -> case fss of { [] -> 0;
								                     x:xs -> case x of { A (n2, e2) -> 1 + cantA (C "" xs) ;
													                     C n2 fss2 -> cantA (C "" xs) + cantA (C "" fss2) }}}
----
-- 5
pertenece :: Nombre -> FS -> Bool 
pertenece = \nom fs -> case fs of { A (n,e) -> n==nom ;
									C n fss -> case fss of {[] -> False;
									                        x:xs ->  case x of { A (n2,e2) -> n2==nom || pertenece nom (C nom xs);
															                     C n2 fss2 -> n2==nom || pertenece nom (C nom fss2) || pertenece nom (C nom xs) }}}
----
-- 6
valido :: FS-> Bool
valido = undefined
-- valido = \fs -> case fs of { A (n,e) -> True;
--                              C n fss -> case fss of { [] -> True;
-- 							 		                 x:xs -> case x of {A (n2,e2) -> nombre(x)==nombre(fs) && and(map valido xs) ;
-- 													 					C n2 fss2 -> n2==n && and(map valido xs) && and(map valido fss2) }}} 
-- 																						-- n era nombre(x)
																				  
----
-- 7
archivosExt :: Ext -> FS -> [Nombre]
archivosExt = \ext fs -> case fs of { A (n,e) -> case e==ext of {True -> [n];
															     False -> []};
									  C n fss -> case fss of {[] -> [];
									                          x:xs -> case x of {A (n2,e2) -> case e2==ext of {True -> [n2] ++ archivosExt ext (C "" xs);
															  												   False -> archivosExt ext (C "" xs)};
																				 C n2 fss2 -> archivosExt ext (C "" fss2) ++ archivosExt ext (C "" xs) }}}

----
-- 8
cambiarNom :: Nombre -> Nombre -> FS -> FS 
cambiarNom = undefined
-- cambiarNom = \nom1 nom2 fs -> case fs of {A (n,e) -> case n==nom1 of { True -> A (nom2,e);
--                                                                        False -> A (n,e) };
-- 	                                      C n fss -> case n==nom1 of { True -> C nom2 fss;
--  										                               False -> case fss of { [] -> C n fss;
-- 																	                           x:xs -> C nom2 (map(cambiarNom nom1 nom2)(xs))}}}
----
-- 9
nivelesC :: FS -> Int
nivelesC = \fs -> case fs of { A (n,e) -> 0;
							   C n fss -> case fss of { [] -> 1 ;
							                            x:xs -> 1+ maximum(map nivelesC fss) }}

----
-- 10
borrar :: Nombre -> FS -> FS 
borrar = undefined
-- borrar = \nom fs -> case fs of { A (n,e) -> fs;	--segun letra, se devuelve el mismo FS recibido
--                                  C n fss -> case n==nom of {True -> error"eliminar carpeta"; 			-- borrar nom (C n fss)
-- 								                            False -> error"no eliminar carpeta"} }
----
-- 11
ordenar :: FS-> FS
ordenar = undefined


