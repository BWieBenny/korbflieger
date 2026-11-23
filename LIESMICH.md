# Korbflieger

Eigenes Korbspiel nach dem Spielprinzip von Flappy Dunk (Mechanik nachgebaut, Name, Figur und Look sind eigen).

**Spiel:** Propellerball, Tippen gibt Schub, von oben durch jeden Korb. Ohne Ringkontakt = Swish (+2 bis +5), ab 3 Swishes Feuer.
- Körbe: normal, mit Brett (ab Korb 7, Ball prallt ab, zählt nicht als Ringkontakt), Goldkorb (jeder 9. ab Korb 9, Swish = 3 Sterne),
  wandernd auf/ab (ab Korb 11), gleitend links/rechts (ab Korb 19). Ringbreite 40 → 29, Tempo 150 → 240.
- Körbe lösen sich auf (Funken, Ring wird größer und blasser, `DISSOLVE` = 0,5 s), sobald alle noch spielenden Spieler durch sind; danach keine Kanten mehr.
  Verpasste Körbe bleiben stehen.
- Extras (Blasen, ab Korb 6): Magnet 8 s (zieht Sterne an), Schild (fängt einen Aufschlag oder verpassten Korb ab), Zeitlupe 5 s (Welt × 0,7).
- Aufträge: immer 3 aktive aus 8 Arten (`MTYPES`), Belohnung 10–50 Sterne, jede Art wird nach Erfüllung schwerer (`mlevels`).
- Zweite Chance: einmal pro Runde für 15 Sterne, Ball wartet über dem nächsten Korb, bis man tippt.
- Erste Runde: gestrichelte Bahn „Von oben rein!“ bis zum ersten Treffer (`korbflieger.tut`). Rekord-Fahne an der Stelle des besten Laufs (`bestX`).
- Vier Himmelszonen (alle 30 Punkte), sechs Bälle (Sterne), Rüttel-Feedback nur auf Android (iOS kann das im Browser nicht).
- Ton: Knopf schaltet Musik und Effekte → nur Effekte → aus (`snd`). Musik wird im Browser erzeugt (Am–F–C–G), Tempo steigt mit der Geschwindigkeit.

**Kamera** (`camTarget`, `updateCam`, nur Darstellung): Zoom 1,1 im Einzelspiel, folgt dem Ball weich in der Höhe und schaut zum nächsten Korb voraus
(62 % Ball, 38 % Korb), Zoom-Ruck bei Swish, Zoom auf den Ball beim Absturz; im Mehrspieler Zoom 1,0 und weiter heraus, wenn die Bälle auseinander sind.
Grenzen: oben `CEIL − 40`, unten Boden; auf hohen Bildschirmen liegt der Boden unten. Hintergrund in Tiefen-Ebenen (`layer(c, p)`: Himmel 0, Sterne 0,06,
Sonne 0,15, Häuser 0,35/0,65, Welt 1). Menü und Mehrspieler-Auswahl zeigen das ruhige Gesamtbild. Die Decke (`CEIL` = −16) ist für alle Bildschirme gleich.

**Mehrspieler an einem Gerät (2–4):** Bildschirm in Spalten, jeder tippt in seine Spalte. Start erst, wenn alle bereit sind, dann Countdown 3-2-1.
Eigene Spuren (32 Punkte Abstand), Bälle stoßen sich ab, Treffer zählen je Spieler (`h.ps[i]`). Verpasst/aufgeschlagen = raus, Ausgeschiedene bleiben zurück,
Runde endet, wenn alle raus sind; Rangliste nach Punkten, dann Körben. Sterne und Goldkörbe geben Punkte statt Sterne, Zeitlupe gilt für alle,
Magnet und Schild nur für den Sammler. Keine Aufträge, kein Rekord, keine Sterne fürs Guthaben. Tastatur: A, L, V, M.

**Mehrere Handys (WLAN, 2–4):** WebRTC ohne Server, nur im selben WLAN oder Hotspot (`iceServers: []`). Bluetooth geht im Browser nicht (Safari hat kein Web Bluetooth).
- Verbinden: Gastgeber zeigt Einladung als QR-Code, Gast scannt und zeigt Antwort-Code, Gastgeber scannt ihn. Ohne Kamera: Code als Text kopieren/einfügen.
  Nach jeder Verbindung wird automatisch die nächste Einladung erzeugt (bis 4 Spieler).
- Codes: SDP auf das Nötigste gekürzt (`packDesc`/`unpackDesc`, Format `K1~typ~setup~ufrag~pwd~fingerprint~kandidaten`, ca. 130–190 Zeichen).
- QR-Werkzeuge werden erst beim Öffnen geladen: `qrcode-generator` 1.4.4 (cdnjs) und `jsQR` 1.4.0 (jsdelivr); der Service Worker hält sie danach offline vor.
- Spiel: Gastgeber rechnet alles (`g.puppet = false`), sendet 30-mal pro Sekunde den Zustand (`snap`) und Ereignisse (`netEvent`: Treffer, Ausscheiden, Extras …).
  Gäste rechnen Bewegung und Stöße selbst (`g.puppet = true`), übernehmen Zustand und Ereignisse (`applySnap`, `applyEvent`) und schicken nur Tipps (`f`) und Bereit (`r`).
  Der eigene Ball des Gasts wird nur sanft nachgeführt, kurz nach einem eigenen Tipp gar nicht (`lastFlap`), damit Tippen ohne Verzögerung wirkt.
- Lebenszeichen jede Sekunde; wer 6 s nichts sendet, gilt als getrennt (im Spiel: raus, im Warteraum: Plätze neu nummeriert). Beim Schließen wird `bye` gesendet.
- Pause gibt es online nicht. Revanche startet nur der Gastgeber. Nicht im claude.ai-Artefakt (dort keine Kamera und kein WebRTC), nur in der installierten App / auf Pages.
- Nicht auf echten Geräten getestet: iPhone ↔ iPhone im WLAN (Safari, mDNS-Adressen). Im Browser getestet: zwei Tabs, gekürzte Codes, QR lesbar, Start, Ergebnis, Revanche, Abbruch.

**Dateien und Abläufe**
- **Quelle:** `korbflieger.html` (Artefakt-Form, ohne `<html>`/`<head>`; dieselbe Datei wird als Artefakt auf claude.ai veröffentlicht).
- **Build:** `bash build.sh` erzeugt `index.html` (Manifest, iOS-Metadaten, Service Worker, auf Handys randlos) und setzt einen neuen Cache-Namen in `sw.js`.
- **Service Worker:** Seitenaufruf zuerst aus dem Netz (Updates kommen sofort an), ohne Netz aus dem Speicher; andere Dateien aus dem Speicher, im Hintergrund erneuert.
- **Bildformat:** Bühne zwischen 3:5 und 9:20; Pixeldichte höchstens 2 (spart Akku). `VIEW_EXTRA` beeinflusst nur die Darstellung, nicht die Simulation.
- **Icons:** `bash icons.sh` rendert `icon.html` mit Edge headless (Edge braucht teils ein paar Sekunden; fehlen PNGs, Skript nochmal starten).
- **Test:** `powershell -File tools\serve.ps1` startet einen Server auf http://127.0.0.1:8765/ (in der App: Vorschau „korbflieger“).
  - `index.html?selftest=1` – 33 Prüfungen: Physik, Punkte, Auflösen, Brett, Schild, Magnet, Zeitlupe, zweite Chance, Aufträge, Korb-Erzeugung, Kamera,
    Mehrspieler, Online (Code-Kürzung, Abgleich ohne und mit 25 ms Verzögerung, echte WebRTC-Verbindung im selben Browser), automatischer Spieler über 12 Läufe,
    zwei Bots im selben Feld über 6 Läufe; Ergebnis im Seitentitel (`SELFTEST OK`, vorher `SELFTEST läuft`).
    Im Testmodus gibt es `window.__kf` (u. a. `show(g, mode)`, um einen vorgespulten Spielstand anzuzeigen).
  - `index.html?bot=1` – der automatische Spieler spielt sichtbar endlos (im verborgenen Browserbereich sehr langsam).
  - `index.html?debug` – `window.__net` zeigt den Verbindungszustand. Online-Test: zwei Tabs, Codes per JavaScript aus `#onCard code` in das Textfeld des anderen Tabs.
  - Nach einem Build eine neue Adresse verwenden (z. B. `&v=2`), sonst liefert der Offline-Speicher bei lokalen Tests ggf. noch die alte Seite.
  - Im verborgenen Browserbereich laufen Timer nach einigen Minuten nur noch einmal pro Minute; Online-Abbruchtests dann mit sichtbarem Bereich machen.
  - Edge headless `--dump-dom` liefert auf diesem Laptop keine Ausgabe, darum der Weg über den Server.
- **Spielwerte** oben im Skript: `GRAV`, `FLAP`, `CEIL`, `ZONE_EVERY`, `REVIVE_COST`, `PW_TIME`, `DISSOLVE`; Körbe in `spawnHoop`, Punkte in `scoreHoop`.
- **Speicher:** `localStorage` mit Schlüsseln `korbflieger.*` (best, bestX, stars, owned, skin, snd, missions, mlevels, totals, tut, mpN), je Gerät und Adresse getrennt.
- **Veröffentlichung:** öffentliches Repo `BWieBenny/korbflieger`, GitHub Pages aus `main`: https://bwiebenny.github.io/korbflieger/ . Nur Pushes auf `main` erreichen das iPhone (Ablauf: Quelle ändern → `bash build.sh` → Commit → Push; Artefakt mit derselben Quelle neu veröffentlichen). Vor dem Push nichts Privates einchecken.
- **Installation iPhone:** Adresse in Safari öffnen → Teilen → „Zum Home-Bildschirm“. Dann randlos und offline.
