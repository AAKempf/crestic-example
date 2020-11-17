# crestic config examples and script files

## Einleitung

Restic, ein wunderbares Backup-Tool, hat leider keine Konfigurationsdatei, um einige Grundparameter wie Passwort, Repositories und die gewünschten Backup-Verzeichnisse einzutragen.

Crestic ist ein Tool von Nils Werner, was diese Parameter als Restic-Wrapper zur Verfügung stellt.

Die Dateien dieses kleinen Projekts können als Beispiel dienen, wie mit crestic und restic gearbeitet werden kann.

## Beispiel 

Bei den zu sichernden Daten handelt es sich um einen Root-Server inkl. dessen Website. Die Website besitzt ein Bild-Verzeichnis von 40 GB, in dem zwei weitere Unterverzeichnisse von etwa 30 GB enthalten sind. 

Gesichert wird ein Repo nur für Code-Dateien, ein Repo für das Bilder-Verzeichnis `/images` und jeweils ein Repo für die beiden Unterverzeichnisse `/images/event` und `/images/flyer`.

```
Repo  : Directory
-----------------
Code  : - html
Code  :   - css
Code  :   - js
Images:   - images
Images:     - data
Images:     - div
Flyer :     - flyer
Photos:     - event
Images:     - website
Code  :   - tpl
```

Umgesetzt ist es in `~/.config/crestic.cfg`, der zentralen Konfigurationsdatei von crestic. Dort werden die Repos, die Backup-Pfade und exclude-Parameter unter eigenem Namen definiert. Zusätzlich gibt es globale Parameter, u.a. den Link zur Passwort-Datei, die --keep-Parameter und einige mehr.

Für den Zugriff auf das Repo reicht am Ende ein stark vereinfachter Befehl 

`$ crestic Code@cloud`

Das Backup wird so gestartet:

`$ crestic Code@cloud backup`

Die Snapshots lassen sich so anzeigen:

`$ crestic Code@cloud snapshots`


## Scripts

Um das ganze möglichst weit zu automatisieren, gibt es drei Scripts:

 `cr_backup.sh`
  Das Backup-Script. Es eignet sich als cronjob. Das Script schreibt eine Log-Datei, die die Dauer pro Repo und die Gesamtdauer erfasst. Es ruft das folgende Script auf:

 `cr_forget.sh`
Dieses Script führt ein `forget` aus. Im Prinzip wie `cr_multi.sh forget`, allerdings findet hier eine wöchentliche Prüfung statt, ob zusätzlich `--prune` ausgeführt werden soll.

`cr_multi.sh [command]`
 Dieses Script ruft alle Repos der Reihe nach auf und führt ein "unlock" aus. Wird ein restic-Befehl übergeben, wird dieser ausgeführt.
 Vor dem ersten Backup müssen z.B. alle Repos initialisiert werden. Das lässt sich mit `cr_multi.sh init` durchführen. Oder falls ein Überblick über alle Snapshots gewünscht ist, wird `cr_multi.sh snapshots` verwendet.
 
Um nicht in allen drei Dateien die zu sichernden Repos eintragen zu müssen, können diese zentral in der Datei
`./.config/restic/backups` stehen. 

## Nutzung

Wer diese Dateien für die Sicherung eines Root-Servers verwenden möchte, sollte sie im Verzeichnis /root installieren.

Weiterhin ist die Datei 'crestic.cfg' und die Dateien im Verzeichnis '.config/restic/' den eigenen Anforderungen anzupassen.