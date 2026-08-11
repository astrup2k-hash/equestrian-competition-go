<<<<<<< HEAD
# Equestrian Competition GO

En lille web-app til at planlægge forberedelse og transport baglæns fra stævnestart —
samme beregningslogik som i `Stævne_planlægning.xlsx`, bare som en app hvor du kan
have flere planer, redigere faserne frit og se det som en tidslinje.

Det er en ren statisk side (én `index.html`, ingen build-trin, ingen backend).
Data gemmes lokalt i din browser (`localStorage`) — der sendes ikke noget til en server.

## Kør lokalt

Åbn bare `index.html` i en browser. Eller, hvis du vil køre den via en lille lokal server:

```bash
npx serve .
# eller
python3 -m http.server 8080
```

## Læg den på GitHub

Jeg kan ikke selv oprette et repository på din GitHub-konto herfra — jeg har ikke adgang
til din konto. Men du er i gang på under 2 minutter:

1. Gå til https://github.com/new og opret et nyt repo, fx `equestrian-competition-go`.
   (Bemærk: GitHub logger man ind med et GitHub-login — der er ikke "login med Google",
   men du kan sagtens bruge din Google-mailadresse som e-mail på GitHub-kontoen.)
2. På din maskine, i denne mappe:
   ```bash
   git init
   git add .
   git commit -m "Første version af Equestrian Competition GO"
   git branch -M main
   git remote add origin https://github.com/<dit-brugernavn>/equestrian-competition-go.git
   git push -u origin main
   ```
3. Gå til repoets **Settings → Pages**, og under "Build and deployment" vælg
   **Source: GitHub Actions**.
4. Det er det. Workflowet i `.github/workflows/deploy.yml` bygger og deployer siden
   automatisk, hver gang du pusher til `main`. Efter første kørsel finder du linket til
   den live side under **Settings → Pages**.

## Struktur

```
equestrian-competition-go/
├── index.html                     – hele appen (HTML + CSS + JS)
├── .github/workflows/deploy.yml   – CI/CD pipeline til GitHub Pages
├── .nojekyll                      – undgår at GitHub Pages Jekyll-behandler filerne
└── README.md
```

## Videre muligheder

- Flere config-parametre pr. fase (fx "kræver hjælper", checkliste-punkter)
- Eksport/import af planer som JSON, så de kan deles mellem enheder
- Flere brugere / cloud-lagring (kræver en rigtig backend, fx Supabase eller Firebase)
=======
# equestrian-competition-go
>>>>>>> 68f95c71fff3b048c23907db22ca6666439bec31
