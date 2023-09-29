___
## Description
This application is designed for creating and storing notes.
The application contains two scenes:

* First scene is a table containing all user notes. Notes in the table are sorted by the date they were last edited and are located in one of five sections: “Pinned”, “Previous 24 hours”, “Previous 7 days”, “Previous 30 days”, “More than 30 days”. Notes can be pinned by clicking on the corresponding button, available after swiping on the cell with the note.;
* Second scene is a text window (UITextView) designed for editing the text of a note. The text window allows you to insert an image from the device's photo gallery when you click on the corresponding button on the keyboard toolbar. Also, it is possible to change the font of the selected text, making it bold, italic and underlined.

Data storage with user notes is implemented using Core Data.
To implement font settings and insert images into a text window, the NSAttributedString class is used, the objects of which are stored in notes as properties.
To create a note in the database when the application is first launched, User Defaults is used, using an object that tracks the first launch.
___
## Описание
Данное приложение предназначено для создания и хранения заметок.
Приложение содержит два рабочих экрана:

* 1 рабочий экран - это таблица, содержащая все заметки пользователя. Заметки в таблице отсортированы по дате последнего редактирования и расположены в одном из пяти разделов: "Закреплено", "Предыдущие 24 часа", "Предыдущие 7 дней", "Предыдущие 30 дней", "Более 30 дней". Заметки можно закреплять, нажав на соответствующую кнопку, доступную после свайпа по ячейке с заметкой.;
* 2 рабочий экран - это текстовое окно (UITextView), предназначенное для редактирования текста заметки. Текстовое окно предполагает возможность вставки изображения из галереи фотографий устройства при нажатии на соответствующую кнопку на панели инструментов клавиатуры. Также, есть возможность изменять шрифт выделенного текста, делая его полужирным, наклонным и подчёркнутым.

Хранение данных с заметками пользователя реализовано с помощью Core Data.
Для реализации настройки шрифта и вставки изображений в текстовое окно используется класс NSAttributedString, объекты которого в виде свойств хранятся в заметках.
Для создания заметки в базе данных при первом запуске приложения используется User Defaults, с помощью объекта которого отслеживается первый запуск.
___
## Application work example:
![demo.gif](Demo.gif)
___