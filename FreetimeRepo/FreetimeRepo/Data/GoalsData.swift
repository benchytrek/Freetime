//
//  GoalsData.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 10.01.26.
//

import Foundation

let sampleGoals: [Goals] = [
    
    // ZIEL 1: BACKFLIP
    Goals(name: "Backflip", tasks: [
        GoalTask(name: "Matte besorgen", isCompleted: true, beschreibung: "Sicherheitsmatte für weiche Landung kaufen"),
        GoalTask(name: "Aufwärmen", isCompleted: true, beschreibung: "Dehnen und Muskulatur vorbereiten"),
        GoalTask(name: "Rolle rückwärts", isCompleted: true, beschreibung: "Grundbewegung am Boden lernen"),
        GoalTask(name: "Hocke üben", isCompleted: true, beschreibung: "Schnelles Anhocken der Beine trainieren"),
        GoalTask(name: "Sprungtechnik", isCompleted: true, beschreibung: "Vertikale Sprunghöhe maximieren"),
        GoalTask(name: "Spotter suchen", isCompleted: false, beschreibung: "Jemanden finden, der Hilfestellung gibt"),
        GoalTask(name: "Macaco", isCompleted: false, beschreibung: "Rückwärtsbewegung über die Seite üben"),
        GoalTask(name: "Erster Versuch", isCompleted: false, beschreibung: "Mit Hilfestellung auf die Matte"),
        GoalTask(name: "Landung verbessern", isCompleted: false, beschreibung: "Sicher auf beiden Füßen landen"),
        GoalTask(name: "Backflip auf Rasen", isCompleted: false, beschreibung: "Der finale Sprung ohne Matte")
    ]),

    // ZIEL 2: FREETIME DEV (APP ENTWICKLUNG)
    Goals(name: "Freetime Dev", tasks: [
        GoalTask(name: "Idee skizzieren", isCompleted: true, beschreibung: "Grobe Funktionen auf Papier bringen"),
        GoalTask(name: "Figma Design", isCompleted: true, beschreibung: "UI/UX Design und Farben festlegen"),
        GoalTask(name: "Projekt aufsetzen", isCompleted: true, beschreibung: "Xcode Projekt und Git Repo erstellen"),
        GoalTask(name: "Datenmodelle", isCompleted: true, beschreibung: "Structs für Goals, Tasks und User anlegen"),
        GoalTask(name: "Mock-Daten", isCompleted: true, beschreibung: "Testdaten für die Preview erstellen"),
        GoalTask(name: "Goals View", isCompleted: false, beschreibung: "Liste der Ziele mit Fortschrittsbalken"),
        GoalTask(name: "Detail View", isCompleted: false, beschreibung: "Timeline Ansicht für einzelne Aufgaben"),
        GoalTask(name: "Navigation", isCompleted: false, beschreibung: "Verbindung zwischen den Views bauen"),
        GoalTask(name: "Datenbank", isCompleted: false, beschreibung: "Speichern der Daten mit SwiftData oder CoreData"),
        GoalTask(name: "App Store Release", isCompleted: false, beschreibung: "App einreichen und veröffentlichen")
    ]),

    // ZIEL 3: ALLGEMEINE ZIELE
    Goals(name: "Allgemeine Ziele", tasks: [
        GoalTask(name: "Jahresplanung", isCompleted: true, beschreibung: "Ziele für das kommende Jahr setzen"),
        GoalTask(name: "Budget checken", isCompleted: true, beschreibung: "Finanzen prüfen und Sparplan erstellen"),
        GoalTask(name: "Urlaub buchen", isCompleted: true, beschreibung: "Reiseziele festlegen und Flüge buchen"),
        GoalTask(name: "Fitness-Check", isCompleted: true, beschreibung: "Gesundheitscheck beim Arzt machen"),
        GoalTask(name: "Bücherliste", isCompleted: true, beschreibung: "5 Bücher auswählen, die ich lesen will"),
        GoalTask(name: "Neue Routine", isCompleted: false, beschreibung: "Morgenroutine etablieren (Meditation/Sport)"),
        GoalTask(name: "Netzwerken", isCompleted: false, beschreibung: "Ein Event pro Monat besuchen"),
        GoalTask(name: "Skill lernen", isCompleted: false, beschreibung: "Eine neue Fähigkeit (z.B. Sprache) lernen"),
        GoalTask(name: "Ausmisten", isCompleted: false, beschreibung: "Wohnung und digitale Daten aufräumen"),
        GoalTask(name: "Review", isCompleted: false, beschreibung: "Rückblick und Anpassung der Ziele")
    ])
]
