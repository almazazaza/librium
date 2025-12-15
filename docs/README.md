# Librium

---

[![Version 0.1a](https://img.shields.io/badge/Version-0%2E1a-blue?logo=github&logoColor=white)](https://github.com/almazazaza/librium/releases) [![Custom License](https://img.shields.io/badge/License-Custom_License-8A2BE2)](./LICENSE.md)  
![Android](https://img.shields.io/badge/Android-5%2D-16-darkgreen?logo=android&logoColor=white) ![iOS](https://img.shields.io/badge/iOS-Not_available-darkblue?logo=iOS&logoColor=white)  
![Flutter version](https://img.shields.io/badge/Flutter-3%2E32%2E2-blue?logo=flutter&logoColor=white) ![Dart version](https://img.shields.io/badge/Dart-3%2E8%2E1-blue?logo=dart&logoColor=white)  

**Librium** — nieoficjalna, bezpłatna aplikacja mobilna z dostępnym kodem źródłowym, służąca do pobierania i wyświetlania danych z serwisu **Librus Synergia**.  
Aplikacja nie jest powiązana z firmą **Librus sp. z o.o.** i korzysta wyłącznie z oficjalnych zasobów systemu.

Kod źródłowy jest publicznie dostępny do wglądu, jednak projekt nie jest Open Source.

Aplikacja została stworzona przez ucznia technikum jako projekt hobbystyczny.

---

# Spis treści

- [Licencja](#licencja)
- [Prywatność](#prywatność)
- [Przykład działania aplikacji](#przykład-działania-aplikacji)
- [Checklist planowanych modułów](#checklist-planowanych-modułów)
- [Wymagania deweloperskie](#wymagania-deweloperskie)
- [Uruchomienie projektu](#uruchomienie-projektu)
- [Wykorzystanie](#wykorzystanie)
- [Przykład programu](#przykład-programu)

---

## Licencja

### ⚖️ Librium Custom License (v1.0)
Projekt Librium jest udostępniany na warunkach **Librium Custom License, Wersja 1.0 (Grudzień 2025)**. Jest to licencja restrykcyjna, nie jest to licencja Open Source (jak MIT, GPL czy Apache).

**Ważne punkty:**

* **Użytek Prywatny → TAK:** Możesz klonować, modyfikować i uruchamiać kod **wyłącznie** na własnych, osobistych urządzeniach w celach niekomercyjnych.
* **Publikacja → TYLKO za zgodą:** Publiczna dystrybucja jakichkolwiek forków, modyfikacji lub dzieł pochodnych jest **zabroniona**, chyba że uzyskasz **pisemną zgodę** od Autora.
* **Dystrybucja Binariów (Sklepy) → NIE:** **Surowo zabrania się** publikowania skompilowanych wersji (APK/IPA/AAB itp.) w jakimkolwiek scentralizowanym sklepie z aplikacjami (Google Play, App Store itp.).
* **Użycie Komercyjne → NIE:** Komercyjne wykorzystanie, sprzedaż, integracja reklam, paywalle lub systemy obowiązkowych darowizn są **ściśle zabronione**.

> Pełny i prawnie wiążący tekst licencji (wersja angielska i polska) znajduje się w pliku **[LICENSE.md](./LICENSE.md)**. Użycie Oprogramowania oznacza automatyczną akceptację wszystkich warunków.

---

## Prywatność
Polityka prywatności aplikacji dostępna jest w pliku [PRIVACY.md](./PRIVACY.md).  
Aplikacja nie przesyła danych użytkownika do żadnych serwerów innych niż oficjalne serwisy Librus.

---

## Przykład działania aplikacji

Przykładowa demonstracja działania aplikacji, szczególnie demonstracja modułu wiadomości:

![Demonstracja działania aplikacji](./preview.gif)

---

## Checklist planowanych modułów
- [x] Informacje
- [x] Wiadomości
- [ ] Ogłoszenia
- [ ] Frekwencja
- [ ] Oceny
- [ ] Uwagi
- [ ] Terminarz

---

## Wymagania deweloperskie
- **Dart >= 3.8.1**
- **Flutter >= 3.32.2**

---

## Uruchomienie projektu
```bash
flutter pub get
flutter run
```

---

## Wykorzystanie
### Logowanie
```dart
// Init new object of class Librus
final Librus librus = await Librus.init();

// Login to Librus Synergia
final LoginStatus status = await librus.authenticate("login", "password");
```

### Moduł: Informacje

```dart
// Get account info (name, surname, class, journal number and other info)
Map<String, dynamic> accountInfo = await librus.getAccountInfo();


// Get lucky number
int? luckyNumber = await librus.getLuckyNumber();
```

### Moduł: Wiadomości

```dart
// Get messages
// Default params:
// int? folderId (default: 5) - load messages from folder with ID = folderId
/*
bool loadAllMessages (default: false)
    false - load only last 50 messages
    true - load all messages
*/
List<Map<String, dynamic>> inbox = await librus.getInbox();

// Get message from folder 5 with message ID 123456
Map<String, dynamic> message = await librus.getMessage(5, 123456);

// Send message to user 1234567
bool isMessageSent = await librus.sendMessage(1234567, "topic", "content");

// Get all receiver types (nauczyciel, wychowawca, admin and other types)
List<Map<String, dynamic>> receiverTypes = await librus.getReceiverTypes();

// Get all receivers with type nauczyciel, groupId = 123456, isVirtualClass = false
// Default params:
// int? classId (default: null) - class ID, optional, should only be used with types like: rada_rodzicow
List<Map<String, dynamic>> receivers = await librus.getReceivers("nauczyciel", 123456, false);
```

---

## Przykład programu
```dart
import 'core/services/Librus/api.dart';

void main() async {
    // Init new object of class Librus
    final Librus librus = await Librus.init();

    // Trying to authorize user
    final status = await librus.authenticate("login", "password");

    // Checking LoginStatus
    if (status == LoginStatus.success) {
        // Getting lucky number
        final luckyNumber = await librus.getLuckyNumber();
        print("Lucky number is: $luckyNumber");

        // Getting account info, firstName and surname
        final accountInfo = await librus.getAccountInfo();
        print("Fullname: ${accountInfo["firstName"]} ${accountInfo["surname"]}\n\n");

        // Getting all messages in inbox
        final inbox = await librus.getInbox(
            folderId: 5,
            loadAllMessages: true
        );
        // Getting messageId and folderId from index 20
        final folderId = inbox[20]["folderId"];
        final messageId = inbox[20]["messageId"];
    
        // Getting message with data
        final message = await librus.getMessage(folderId, messageId);
        print("Message $messageId($folderId)\n");
        print("Sender: ${message["meta"]["sender"]}");
        print("Topic: ${message["meta"]["topic"]}");
        print("Content: ${message["plainText"]}");

        // Closing session
        await librus.destroySession();
        return;
    }
    else {
        // Login not successful, print error message
        print("Login error: ${status.message}");
        return;
    }
}
```