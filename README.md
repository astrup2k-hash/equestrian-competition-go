# Equestrian Competition GO

En web-app til at planlægge forberedelse og transport baglæns fra stævnestart —
samme beregningslogik som i `Stævne_planlægning.xlsx`. Planer deles automatisk
med alle i din "stald" (din gruppe), og alle logger ind med deres Google-konto.

Stadig én statisk `index.html` (ingen build-trin) — men nu med en rigtig backend
via [Supabase](https://supabase.com) til login og delt data.

## Sådan hænger det sammen

- **Login:** Google, via Supabase Auth
- **Deling:** man er medlem af én "stald" ad gangen. Alle planer i stalden er
  synlige og redigerbare for alle medlemmer, og opdateres i realtid (Supabase Realtime)
- **Data:** gemmes i en Postgres-database hos Supabase, beskyttet af Row Level
  Security, så kun medlemmer af en stald kan se dens planer

## Opsætning (ca. 10 minutter, kun én gang)

### 1. Opret Supabase-projekt
1. Gå til https://supabase.com → **New project** (gratis niveau er rigeligt)
2. Vent til projektet er klar (~2 min)

### 2. Kør databaseskemaet
1. I Supabase Dashboard: **SQL Editor → New query**
2. Indsæt hele indholdet af `supabase/schema.sql` fra dette repo, og tryk **Run**

### 3. Slå Google-login til
1. I Google Cloud Console (https://console.cloud.google.com):
   - Opret et projekt (eller brug et eksisterende)
   - **APIs & Services → OAuth consent screen** → udfyld basale oplysninger
   - **APIs & Services → Credentials → Create credentials → OAuth client ID**
     - Application type: **Web application**
     - Under **Authorized redirect URIs**, tilføj den URL Supabase viser dig i næste trin
       (typisk `https://<dit-projekt>.supabase.co/auth/v1/callback`)
   - Kopiér **Client ID** og **Client secret**
2. I Supabase Dashboard: **Authentication → Providers → Google**
   - Slå den til, indsæt Client ID + Client secret fra Google, gem

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
Samme fremgangsmåde som før — se trinene nedenfor.

1. Gå til https://github.com/new og opret et repo, fx `equestrian-competition-go`
   (GitHub har ikke "login med Google", men du kan bruge din Google-mail som
   e-mail på GitHub-kontoen)
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

**Vigtigt:** når du kender din endelige GitHub Pages-URL (fx
`https://dit-brugernavn.github.io/equestrian-competition-go/`), skal den også
tilføjes som en **Authorized redirect URI** i Google Cloud Console og under
**Authentication → URL Configuration → Redirect URLs** i Supabase — ellers
afviser Google login fra den live side.

## Sådan bruges "stalde"

- Første gang man logger ind, skal man enten **oprette** en ny stald (får en
  6-cifret invitationskode) eller **tilslutte** sig en eksisterende med en kode
  fra en holdkammerat
- Alle i samme stald ser automatisk de samme planer, og ændringer synkroniseres
  live til alle andre der har siden åben
- Invitationskoden kan altid findes/kopieres i toppen af appen, når man er logget ind

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

- **"Appen er ikke sat op endnu"** på login-skærmen → CONFIG-værdierne i
  `index.html` er ikke udfyldt endnu (trin 4)
- **Google-login fejler / redirect-fejl** → tjek at både Google Cloud Console og
  Supabase har den *præcise* redirect-URL, inkl. `https://` og uden trailing slash-fejl
- **Man kan ikke se andres planer** → tjek at begge er medlem af samme stald
  (samme invitationskode brugt), og at `supabase/schema.sql` er kørt igennem uden fejl
