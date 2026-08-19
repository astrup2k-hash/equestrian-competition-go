# Equestrian Competition GO

En web-app til at planlægge forberedelse og transport baglæns fra stævnestart —
samme beregningslogik som i `Stævne_planlægning.xlsx`. Planer deles automatisk
med alle i din "stald" (din gruppe). Man opretter sin egen bruger med e-mail
og adgangskode.

Stadig én statisk `index.html` (ingen build-trin) — men med en rigtig backend
via [Supabase](https://supabase.com) til login og delt data.

## Sådan hænger det sammen

- **Login:** e-mail + adgangskode, oprettet direkte i appen (Supabase Auth)
- **Deling:** man er medlem af én "stald" ad gangen. Alle planer i stalden er
  synlige og redigerbare for alle medlemmer, og opdateres i realtid (Supabase Realtime)
- **Data:** gemmes i en Postgres-database hos Supabase, beskyttet af Row Level
  Security, så kun medlemmer af en stald kan se dens planer

## Opsætning (ca. 5 minutter, kun én gang)

### 1. Opret Supabase-projekt
1. Gå til https://supabase.com → **New project** (gratis niveau er rigeligt)
2. Vent til projektet er klar (~2 min)

### 2. Kør databaseskemaet
1. I Supabase Dashboard: **SQL Editor → New query**
2. Indsæt hele indholdet af `supabase/schema.sql` fra dette repo, og tryk **Run**

### 3. (Valgfrit, men anbefalet til at starte med) Slå e-mail-bekræftelse fra
Som standard kræver Supabase at nye brugere bekræfter deres e-mail via et link,
før de kan logge ind. Det er fint i produktion, men kan være besværligt mens du
tester lokalt:
1. **Authentication → Providers → Email**
2. Slå **"Confirm email"** fra, hvis du vil kunne oprette og bruge en konto med
   det samme uden at skulle bekræfte via mail

### 4. Indsæt nøgler i appen
1. I Supabase Dashboard: **Project Settings → API**
2. Kopiér **Project URL** og **anon public key**
3. Åbn `index.html`, find blokken der hedder `CONFIG` (øverst i `<script>`-taggen)
   og indsæt værdierne:
   ```js
   const CONFIG = {
     supabaseUrl: "https://xxxxxxxx.supabase.co",
     supabaseAnonKey: "eyJhbGciOi..."
   };
   ```

### 5. Læg den på GitHub og deploy
1. Gå til https://github.com/new og opret et repo, fx `equestrian-competition-go`
2. På din maskine, i denne mappe:
   ```bash
   git init
   git add .
   git commit -m "Første version af Equestrian Competition GO"
   git branch -M main
   git remote add origin https://github.com/<dit-brugernavn>/equestrian-competition-go.git
   git push -u origin main
   ```
3. Repoets **Settings → Pages → Source: GitHub Actions**
4. Efter første push finder du live-linket under **Settings → Pages**

## Sådan bruges appen

1. **Opret en konto** på login-skærmen (e-mail + adgangskode, mindst 6 tegn)
2. Første gang man logger ind, skal man enten **oprette** en ny stald (får en
   6-cifret invitationskode) eller **tilslutte** sig en eksisterende med en kode
   fra en holdkammerat
3. Alle i samme stald ser automatisk de samme planer, og ændringer synkroniseres
   live til alle andre der har siden åben
4. Invitationskoden kan altid findes/kopieres i toppen af appen, når man er logget ind

## Struktur

```
equestrian-competition-go/
├── index.html                     – hele appen (HTML + CSS + JS), incl. Supabase-integration
├── supabase/schema.sql            – databasetabeller, RLS-politikker og realtime-opsætning
├── .github/workflows/deploy.yml   – CI/CD pipeline til GitHub Pages
├── .nojekyll
└── README.md
```

## Fejlfinding

Appen viser nu en fejlskærm med detaljer, hvis noget går galt under login —
det gør det meget nemmere at se hvad der er galt end tidligere.

- **"relation ... does not exist"** → `supabase/schema.sql` er ikke kørt endnu (trin 2)
- **"Email not confirmed"** → enten bekræft via linket i mailen du modtog, eller
  slå "Confirm email" fra som beskrevet i trin 3
- **"Appen er ikke sat op endnu"** på login-skærmen → CONFIG-værdierne i
  `index.html` er ikke udfyldt endnu (trin 4)
- **Man kan ikke se andres planer** → tjek at begge er medlem af samme stald
  (samme invitationskode brugt)
