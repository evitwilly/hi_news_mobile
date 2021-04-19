# hi_news

hi_news - мобильное Android приложение, которое на данный момент имеет стабильную версию. Вы можете скопировать код приложения и собрать его под себя.

## Почему hi_news?

hi_news предоставлят ряд возможностей для своих пользователей:

1) Возможность просматривать новости по различным тематикам (в основном, научно-технические)
2) Возможность поиска по всем опубликованным новостям
3) Возможность сохранять новости для оффлайн просмотра
4) Удобный и простой интерфейс

## Экраны

Скоро будут

## Немного о Backend приложухи

API полностью написан на PHP Android разрабом, поэтому не представляет из себя панацею новостного API.

Запросы выполняются по адресу: https://rubteh.ru/rub2time/{api_method_or_script}

Кодировка ответа: **UTF_8**

Формат ответа: **JSON**

Основные методы и скрипты API(все методы являются GET методами):

**get_themes.php** - возвращает список тем в формате 

```
[
  { id: "mars", title: "Планета Марс"}, 
  { id: "tesla", title: "Tesla" },
  ...
] 
```

Основные параметры:
* access_key (обязательный) - ключ API


**get_news.php** - вовращает список новостей в формате: 

Ошибка:
```
{ 
  "status": "error"
  "message": "..."
}
```
Успешное выполнение:
```
{
  "status": "success"
  "data": {
    "page_status": "no_exists|last_page|no_last_page",
    "news": [
      { "url": "https://hi-news.ru/science/uchenye-smogli-opredelit-urovn-vitamina-c-cheloveka-bez-analiza-krovi.html",
        "urlToImage": "https://hi-news.ru/wp-content/uploads/2020/05/pribor_c-650x433.jpeg",
        "title": "Ученые смогли определить уровень витамина C человека без анализа крови",
        "author": "Александр Богданов"
        "date": "28.05.2020"
        "desc": "Самым распространённым способом определения концентрации веществ в организме на текущий день является анализ крови. 
        Он не только позволяет узнать содержание витаминов, уровень гормонов и другие показатели здоровья человека, 
        но и также способен помочь диагностировать заболевания и наличие опасных вирусов. Однако этот способ инвазивный, 
        то есть требует непосредственного проникновения в организм, и не у всех зачастую есть возможность сдать анализ крови. 
        Людям с диабетом, например, по этой причине приходится носить с собой портативные устройства, способные определять 
        содержание сахара в крови. За последние несколько лет ученые начали создавать носимые датчики, которые позволяют не брать анализ крови для 
        определения концентрации одного вещества. Один из таких недавно представили исследователи из США и Швейцарии."
      },
      ...
    ]
  }
}
```
Основные параметры:

* theme (обязательный) - указание идентификатора темы
* access_key (обязательный) - ключ API
* page (не обязательный) - номер страницы
 
 
**search.php** - возвращает новости по строке поиска (query)

Ответ аналогичный **get_news.php**

Основные параметры:
* access_key (обязательный) - ключ API
* query (обязательный) - строка поиска
* page (необязательный) - номер страницы

**get_content.php** - возвращает контент новости по ссылке (самая простая реализация)

Ошибка:
```
{ 
  "status": "error"
  "message": "..."
}
```
Успешное выполнение:
```
{
  "status": "success"
  "data": {
    "content_status": "exists|no_exists",
    "content": [
      
      "Когда-то очень давно Марс мог быть настоящим раем для органической жизни: на его поверхности плескались моря, 
      плотная атмосфера защищала планету от падения астероидов, а теплый климат способствовал развитию жизни. Так продолжалось недолго: 
      в результате еще неизученной нами катастрофы, атмосфера планеты вдруг истончилась, магнитное поле погасло, а моря и океаны нашего 
      космического соседа или испарились, или ушли глубоко под его поверхность. Все, что осталось со дня грандиозной катастрофы планетарного 
      масштаба; ржавый песок, камни и разнообразные скалистые обломки &#8212; совсем не похоже на то, чем являлась четвертая планета в глубокой 
      древности. Надеясь найти остатки бактерий, возможно обитавших на Марсе до загадочного смертоносного события, ученые раз за разом отправляли 
      в этот пустынный мир большое количество разнообразных миссий, однако попытки их поисков оставались долгое время тщетными. Или все-таки нет?",
      
      "Второй параграф",
      
      "Третий и т.д."
      
    ]
  }
}
```
Ответ может содержать специальные HTML символы, такие как: &#xxxx (в шестнадцеричном формате)

Основные параметры:
* access_key (обязательный) - ключ API
* link (обязательный) - ссылка на страницу новости (параметр url из ответа **get_news.php** или **search.php**)

