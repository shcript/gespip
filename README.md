# Manual de gesPIP v4.0 20/02

## Autors

[Grup d'usuaris de Gnu/Linux «La Pipa Plena»] (http://www.lapipaplena.org)

[Associació pel programari lliure de Catalunya] (http://www.catplus.cat)


## NOVETATS v4.0

S'ha fet una actualització del gespip. Ara s'ha d'executar amb argument (gespip pipa) i aquest argument serà el que donarà nom al directori de treball. Fins ara aquest directori (~/pipa) estava dins de l'script i clar, no tenia sentit que la gestió de catplus es fes en un directori que digues pipa.

Una vegada fet el git pull, abans d'executar-lo novament, fes;

```
mv pipa Catplus
```
I per executar-lo:

```
gespip Catplus
```

Això permet gestionar totes les associacions que es vulguin en un mateix PC, donat que cadascuna d'elles tindrà el seu propi directori. Si l'arrenquem sense arguments, ja l'informarà l'script de com s'ha de fer. Veurà també que l'argument surt en el Main Menú. Si vol estalviar-te de posar l'argument cada cop, pots crear un alias com fem:

```
nano .bashrc
```
I afegir la linea:
```
alias gespip='gespip Catplus'
```
Aquesta versió 4.0 fa l'script molt més versàtil.

## Descripció
gesPIP es un shell script en Bash, per a gestionar una associació qualsevol, amb els preceptius comptes de socis, caixa i actes, obligatoris en tota associació malgrat que ara ja poden èsser gestionats en format digital. De cadascuna de les opcions implementades al gesPIP s'en mostra un exemple dins les seves funcionalitats d'altes, baixes, modificacions i consultes.

## Història
Aquest script va partir d'un primer menú dissenyat per cat+ que amb funcions de centrat, s'inspirava en els antics menus de terminal vt100 del SunOS en clara reivindicació a l'extrema usabilitat de les aplicacions en línia de comandaments, tant per l'austeritat de recursos necessaris com i sobretot, per la seva ràpida portabilitat dins qualsevol sistema Gnu/Linux/UNIX/BSD. 

El projecte inicialment conceptualitzat, va ser llavors desenvolupat opció per opció pel Grup d'usuaris de Gnu/Linux «La Pipa Plena» implementant totes i cadascuna de les opcions.

## Portabilitat
gesPIP.sh no comporta dependències d'altre programari o llibreries, permetent una portabilitat sense cap dependència funcional de BBDD ni d'altres aplicacions de servidor. Les dades, es generen com arxius plans de text en format CSV. En el cas de precisar la portabilitat de gesPIP amb dades ja emmagatzemades, ens haurem de recordar de copiar també aquests arxius.

Només i en el cas de fer ús de l'opció de contrasenyes amb encriptació, precisarem les llibreries esmentades al Require.

## Presentació del menú principal (MAIN MENU)
```
Entrades contables............ a	Consultar saldo............... b
Últimes entrades contabilitat. c	Tot el regitre contable....... d
Esborrar entrada contable..... e	Nom i correu dels socis ...... f
Mostrar dades soci concret.... g	Entrar un nou soci............ h
Donar de baixa un soci........ i	Llistat exsocis............... j
Fer copies seguretat.......... k	Consultar backup anterior..... l
Entrar quota soci............. m	Revisar codi.................. n
Editar privat................. o	Editar arxius mestres......... p
Enviar correu als socis....... r	Tancar gestió................. Q
```
![screenshot del gesPIP](https://pbs.twimg.com/media/CWx-C5mWoAAO6kc.png:large)

## Opcions del menú

### [a] Entrades comptables

### [b] Consultar saldo

### [c] Últimes entrades comptab.

### [d] Tot el registre comptable

### [e] Esborrar entrada comptable

### [f] Nom i correu dels socis

### [g] Mostrar soci complert

### [h] Entra un nou soci

### [i] Donar de baixa un soci

### [j] Llistar exSocis

### [k] Fer còpies seguretat

### [l] Consultar backup anterior

### [m] Entrar quota soci

### [n] Revisar codi

### [n] Editar privat

### [p] Editar arxius mestres

### [r] Enviar correu als socis

### [Q] Tancar gestió


## Dades tècniques
```
  # Date.......: 29-12-2015
  # Author.....: "lapipaplena" <lapipaplena@gmail.com>
  # UX Design..: "Catplus" <info@catplus.cat>
  # Version....: 2.5
  # Licence....: GPL v3.0
  # Description: Programa de gestió d'associacions de linux
  # Require....: ccrypt sendemail libnet-ssleay-perl libio-socket-ssl
```


