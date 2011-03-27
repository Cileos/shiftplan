#Features (reworked definition)
Mit diesem File soll begonnen werden, alle bislang besprochenen Features auf den Prüfstand zu stellen.
Das Ziel ist, zu bewerten, ob ein Projektneustart auch auf Ebene der Codebase notwendig wird.
Die Features werden nach Themenbereichen gruppiert. Die atomarste Ebene ist ein ausführbares Cucumber-Feature.

**Version notes**

2011-03-20	FT	initial brainstorming list aller features, die mir so eingefallen sind. Muss noch auf cucumber style gebracht werden.

-------------------------------------------------

##Setup

**Mitarbeiter/Users/Rollen**

- Mitarbeiter werden mit ihren Qualifikationen erfasst
- Mitarbeiter sind gleichzeitig auch User mit eigener Anmeldung
- es gibt nur drei Rollen:
  - Benutzer -> einfacher Mitarbeiter, der sein Profil und seine Verfügbarkeiten pflegt
  - Planer -> vom Admin bestimmte User, die Pläne bearbeiten dürfen
  - Admin -> der Account-Admin und gleichzeitig auch Planer 
- Daten können per Import/Export bearbeitet werden (Excel-Listen)

**Arbeits- oder Einsatzplätze**

- Arbeits- oder Einsatzplätze sind die Orte für die eine Schicht in einem Plan erstellt wird
- sie beinhalten die benötigten Qualifikationen und standardmäßige Anzahl dieser, außerdem kann die Standardlänge einer Schicht erfasst werden

##Verfügbarkeiten

- Unterscheidung von internen und externen Mitarbeitern erfolgt durch die Art der Erfassung von Verfügbarkeiten
- die Erfassung wird durch Kalenderansichten unterstützt

**Defaults**

- Erfassung eines Standardverfügbarkeitsmusters auf Basis von Wochentagen (für interne Mitarbeiter, bei denen man per se von einer Verfügbarkeit zu den Business-Zeiten ausgeht)
- wird als Grundlage bei der Planung verwendet, wenn keine Verfügbarkeit für ein spezielles Datum angegeben ist
- Beispiel: wenn es für Montag, 25.10.2010 keine dedizierte Verfügbarkeit für einen Mitarbeiter gibt, wird geschaut, ob es eine Standardverfügbarkeit für den Wochentag Montag gibt

**Verfügbarkeit**

- anders als ein interner Mitarbeiter ist ein Externer per se nicht standardmäßig verfügbar
- er muss angeben, wann er für Einsätze geplant werden kann
- dies erfolgt durch Angabe des Datums und der Uhrzeit bzw. Bereich der Uhrzeit

**Nichtverfügbarkeit**

- wenn es eine Standardverfügbarkeit für einen Mitarbeiter gibt, er aber an einem bestimmten Datum nicht verfügbar ist, wird dies als Nichtverfügbarkeit erfasst
- es erfolgt keine Trennung bzw. Kategorisierung der Nichtverfügbarkeiten (Urlaub, Krankheit, Schulung etc.), es wird aber nach einer generischen Lösung für das Problem gesucht, da die Relevanz für den Planungsprozess gegeben ist (bei Fehlen von ausreichend Mitarbeitern, kann anhand der Art der Nichtverfügbarkeit entschieden werden, welche Mitarbeiter man um Verfügbarkeit bittet; jemand der krank ist kann nicht zurückgeholt werden, jemand auf Schulung oder im Urlaub schon eher)

##Schichtpläne

**Der Plan**

- anders als in anderen Systemen ist der Ausgangspunkt der Planung nicht das Datum, sondern der Plan
- durch den freiwählbaren Datumsbereich kann von der Langfristplanung bis zum Event alles erfasst werden
- so kann es an einem Tag einen allgemeinen Arbeitsplan geben und parallel dazu ein Eventplan

**Templates**

- viele Pläne sind wiederverwendbar, man muss lediglich den Geltungsbereich anpassen
- dazu kann man sich sogenannte Planschablonen definieren und die als Basis eines neuen Planes verwenden
- dabei kann auch der Detailgrad der zu übernehmenden Daten spezifiziert werden (nur Arbeitsplätze, Arbeitsplätze und Qualifikationsanforderungen, Alles)

**Planning**

- die Planung erfolgt auf Basis eines 15-Minuten-Rasters, das für die Anzahl der angegeben Planstunden und über den angegebenen Datumsbereich geht
- die Planung der Bestandteile eines Plans erfolgt als Drag&Drop der Elemente; d.h. man zieht einen Arbeitsplatz auf das Raster und platziert ihn am gewünschten Tag zur gewünschten Startzeit, anhand der vordefinierten Länge einer Schicht (beim Arbeitsplatz, s.o.) wird ein Balken über das Raster gelegt; die Position des Balkens kann verändert werden, ebenso die Anfangs- und Endpunkte für die Änderung der Schichtlänge; wenn es vordefinierte Qualifikationsanforderungen für den Arbeitsplatz gibt, werden diese auf dem Balken als anonymisierter, farblich markierter Thumbnail angezeigt, die Korrektur der Anzahl erfolgt ebenfalls per Drag&Drop
- die Zusammenführung der zu besetzenden Schichten, Qualifikationen und Mitarbeiter erfolgt ebenfalls per Drag&Drop; anders aber als zuvor wird anhand der beim Mitarbeiter vordefinierten Qualifikationen und Verfügbarkeiten eine visuelle Unterstützung bei der Planung gegeben: wird ein Mitarbeiter auf das Raster gezogen, werden alle nicht-relevanten Schichten und Qualifikationen auf dem Raster ausgegraut; wird eine Schicht- oder eine Qualifikation per Klick markiert, werden alle nicht-relevanten Mitarbeiter ausgeblendet
- ein dediziertes Speichern ist nicht notwendig, da alle Änderungen fortlaufend in die Datenbank geschrieben werden 
- in Zukunft soll es die Möglichkeit geben, sich vom System einen Besetzungsvorschlag erstellen zu lassen 
- (Splitschichten: 2 MA teilen sich eine Schicht oder verlängert seine Schicht um den fehlenden Teil einer anderen Schicht)
- (Indikator für außergewöhnliche Besetzungen: z.B. Doppelschicht)
- (tagesübergreifende Schichten)

**Shift Trading**

- unter shift trading wird die Möglichkeit des Schichttausches gefasst
- wenn ein Mitarbeiter für eine Schicht geplant wurde, aber diese gern tauschen möchte, kann er den Termin zur Verfügung stellen
- die Zurverfügungstellung kann er an alle oder nur verfügbare/qualifizierte adressieren
- Interessenten können sich die Schicht zuordnen
- die Anfrage kann mehrfach gesendet werden, wenn sich keiner auf die erste Anfrage meldet
- zu überlegen ist, inwieweit der Manager dem Tausch zustimmen muss
- weiterhin wurde angefragt, ob ein teilweises Übernehmen möglich ist

**Reporting**

- die Applikation unterscheidet nicht in "Wer darf welchen Plan bearbeiten?"; dies wird über ein Aktivitätslog in Form einer sozialen Kontrolle durchgeführt
- aus den erstellten Plänen können die verschiedenen Ansichten erstellt werden; für jede Ansicht ist eine Druckversion in Form eines PDF-Dokuments vorgesehen
- für Planer sind unterschiedliche Sichten nach Mitarbeitern oder Arbeitsplätzen vorgesehen
- Mitarbeitern wird fortlaufend ein aktueller Arbeitsplan mit Kennzeichnung von Nichtverfügbarkeiten angeboten

##Tags

- die Applikation kennt keine vordefinierten Kategorisierungen für organisationstechnische oder geografisch Aspekte
- dies soll über freidefinierbare Suchbegriffe dem Unternehmen überlassen werden
- die Applikation bietet in jeder Ansicht eine Live-Filter-Funktion

##Messaging Center

**System notifications**

- als system notifications werden alle Meldungen gesehen, die durch system-definierte Ereignisse ausgelöst werden
- solche Ereignisse sind:
  - Mitarbeiter wurde für eine Schicht geplant -> Meldung an Mitarbeiter
  - Mitarbeiter wurde aus einem Plan gelöscht -> Meldung an Mitarbeiter
  - Mitarbeiter wird über bevorstehenden Schichtbeginn informiert (kann individuell eigestellt werden; bis zu 2 Erinnerungen möglich)
  - Mitarbeiter hat seine Verfügbarkeit für einen bereits geplanten Zeitraum verändert -> Meldung an Planer
  - jemand hat einen Plan geändert, dessen Ersteller er nicht war -> Meldung an Planer/Ersterfasser
  - es liegt kein Plan mehr vor -> Meldung an Planer

**Communication**

- hier werden die freien Nachrichten zusammengefasst, die
  - der Admin an alle Benutzer schicken kann, um über Ereignisse zu benachrichtigen (Wartungen etc.)
  - ein Planer an alle (nicht verplanten) Mitarbeiter schicken kann, wenn ihm für einen Plan noch Leute fehlen
  - ein Planer an einzelne Mitarbeiter schicken kann, um mit ihnen Einsätze zu kommunizieren
  - ein Mitarbeiter an einzelne oder alle Mitarbeiter, wenn er für einen Einsatz Ersatz sucht und Tausch anbietet
- es erfolgt eine Ansicht der Nachrichtenbox im Dashboard unter Markierung der Quelle und der Adressaten (Einzel- oder Gruppennachricht)

##Integration

**Ist-Zeiten**

- es ist vorgesehen, dass neben der Planung eine einfache Variante der Ist-Zeiten-Erfassung möglich ist
- in diese Ist-Zeitenerfassung lässt sich auch die Auswertung von Fehlzeiten wie Urlaub, Krankheit etc. realisieren
- wenn eine generische Lösung für die Trennung und Kategorisierung von Nicht-Verfügbarkeiten gefunden wurde, ist eine Darstellung von Urlaubsplänen möglich

**Interfaces**

- mit der Realisierung der Ist-Zeiten-Erfassung bietet sich an, diese auch in geeigneter Weise anderen Systemen wie Lohn und Gehalt zur Verfügung zu stellen
- wie zuvor schon erwähnt ist bereits jetzt eine Schnittstelle für den Im- und Export von Mitarbeitern vorhanden

**API's**

- es soll grundsätzlich die Möglichkeit bestehen, mit anderen Programmen (z.B. iPhone-App etc.) auf die Applikationsdaten zu zugreifen