# Korbflieger

Eigenes Korbspiel nach dem Spielprinzip von Flappy Dunk (Mechanik nachgebaut, Name, Figur und Look sind eigen).

**Spiel:** Propellerball, Tippen gibt Schub, von oben durch jeden Korb. Ohne Ringkontakt = Swish (+2 bis +5), ab 3 Swishes Feuer.
- Körbe: normal, mit Brett (ab Korb 7, Ball prallt ab, zählt nicht als Ringkontakt), Goldkorb (jeder 9. ab Korb 9, Swish = 3 Sterne),
  wandernd auf/ab (ab Korb 11), gleitend links/rechts (ab Korb 19). Ringbreite 40 → 29, Tempo 150 → 240.
- Extras (Blasen, ab Korb 6): Magnet 8 s (zieht Sterne an), Schild (fängt einen Aufschlag oder verpassten Korb ab), Zeitlupe 5 s (Welt × 0,7).
- Aufträge: immer 3 aktive aus 8 Arten (`MTYPES`), Belohnung 10–50 Sterne, jede Art wird nach Erfüllung schwerer (`mlevels`).
- Zweite Chance: einmal pro Runde für 15 Sterne, Ball wartet über dem nächsten Korb, bis man tippt.
- Erste Runde: gestrichelte Bahn „Von oben rein!“ bis zum ersten Treffer (`korbflieger.tut`).
- Vier Himmelszonen (alle 30 Punkte), sechs Bälle (Sterne), Rüttel-Feedback nur auf Android (iOS kann das im Browser nicht).

**Dateien und Abläufe**
- **Quelle:** `korbflieger.html` (Artefakt-Form, ohne `<html>`/`<head>`; dieselbe Datei wird als Artefakt auf claude.ai veröffentlicht).
- **Build:** `bash build.sh` erzeugt `index.html` (Manifest, iOS-Metadaten, Service Worker, auf Handys randlos) und setzt einen neuen Cache-Namen in `sw.js`.
- **Bildformat:** Bühne zwischen 3:5 und 9:20; auf hohen Bildschirmen wächst der Himmel nach oben (`VIEW_EXTRA`), Spielfeld unten bleibt gleich.
- **Icons:** `bash icons.sh` rendert `icon.html` mit Edge headless (Edge braucht teils ein paar Sekunden; fehlen PNGs, Skript nochmal starten).
- **Test:** `powershell -File tools\serve.ps1` startet einen Server auf http://127.0.0.1:8765/ (in der App: Vorschau „korbflieger“).
  - `index.html?selftest=1` – 20 Prüfungen (Physik, Punkte, Brett, Schild, Magnet, Zeitlupe, zweite Chance, Aufträge, Korb-Erzeugung) plus automatischer Spieler über 12 Läufe; Ergebnis im Seitentitel (`SELFTEST OK`).
    Im Testmodus gibt es `window.__kf` (u. a. `show(g)`, um einen vorgespulten Spielstand anzuzeigen).
  - `index.html?bot=1` – der automatische Spieler spielt sichtbar endlos (im verborgenen Browserbereich sehr langsam).
  - Edge headless `--dump-dom` liefert auf diesem Laptop keine Ausgabe, darum der Weg über den Server.
- **Spielwerte** oben im Skript: `GRAV`, `FLAP`, `ZONE_EVERY`, `REVIVE_COST`, `PW_TIME`; Körbe in `spawnHoop`, Punkte in `scoreHoop`.
- **Speicher:** `localStorage` mit Schlüsseln `korbflieger.*` (best, stars, owned, skin, muted, missions, mlevels, totals, tut), je Gerät und Adresse getrennt.
- **Veröffentlichung:** bisher nur als privates claude.ai-Artefakt. Für die Installation als App auf dem iPhone (wie Himmelhüpfer) bräuchte es ein GitHub-Repo mit Pages.
