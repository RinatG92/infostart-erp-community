﻿// Задает вопрос о продолжении действия, которое приведет к потере изменений:
// "Данные были изменены. Сохранить изменения?" 
// Для использования в обработчиках события ПередЗакрытием модулей форм объектов,
// которые возможно записать в информационную базу.
// Отображение вопроса зависит свойства модифицированности формы.
// Для отображения вопроса произвольной формы используйте: 
//  см. процедуру ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы().
//
// Параметры:
//  ОповещениеСохранитьИЗакрыть  - ОписаниеОповещения - содержит имя процедуры, вызываемой при нажатии на кнопку OK.
//  Отказ                        - Булево - возвращаемый параметр, признак отказа от выполняемого действия.
//  ЗавершениеРаботы             - Булево - признак того, что форма закрывается в процессе завершения работы приложения.
//  ТекстПредупреждения          - Строка - текст предупреждения, выводимый пользователю. По умолчанию, выводится текст
//                                          "Данные были изменены. Сохранить изменения?"
//  ТекстПредупрежденияПриЗавершении - Строка - возвращаемый параметр с текстом предупреждения, выводимым пользователю 
//                                          при завершении приложения. Если параметр указан, то возвращается текст
//                                          "Данные были изменены. Все изменения будут потеряны.".
//
// Пример:
//
//  &НаКлиенте
//  Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
//    Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
//    ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
//  КонецПроцедуры
//  
//  &НаКлиенте
//  Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
//     // записываем данные формы.
//     // ...
//     Модифицированность = Ложь; // не выводить подтверждение о закрытии формы еще раз.
//     Закрыть(<РезультатВыбораВФорме>);
//  КонецПроцедуры
//
Процедура ПоказатьПодтверждениеЗакрытияФормы(Знач ОповещениеСохранитьИЗакрыть, Отказ, Знач ЗавершениеРаботы, Знач ТекстПредупреждения = "", ТекстПредупрежденияПриЗавершении = Неопределено) Экспорт
	Форма=ОповещениеСохранитьИЗакрыть.Модуль;
	Если Не Форма.Модифицированность Тогда Возврат; КонецЕсли;
	
	Отказ = Истина;
	
	Если ЗавершениеРаботы Тогда
		Если ТекстПредупрежденияПриЗавершении="" Тогда // передан параметр из ПередЗакрытием
			ТекстПредупрежденияПриЗавершении=НСтр("ru = 'Данные были изменены. Все изменения будут потеряны.'");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Параметры=Новый Структура();
	Параметры.Вставить("ОповещениеСохранитьИЗакрыть", ОповещениеСохранитьИЗакрыть);
	Параметры.Вставить("ТекстПредупреждения", ТекстПредупреждения);
	
	ИмяПараметра="СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы";
	Если ПараметрыПриложения[ИмяПараметра]=Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Неопределено);
	КонецЕсли;
	
	ТекущиеПараметры=ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"];
	Если НЕ ТекущиеПараметры=Неопределено И ТекущиеПараметры.ОповещениеСохранитьИЗакрыть.Модуль=Параметры.ОповещениеСохранитьИЗакрыть.Модуль Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПодтвержденияЗакрытияФормы"]=Параметры;
	
	Форма.Активизировать();
	ПодключитьОбработчикОжидания("ПодтвердитьЗакрытиеФормыСейчас", 0.1, Истина);	
КонецПроцедуры

// Предлагает пользователю установить расширение работы с файлами в веб-клиенте.
// Предназначена для использования в начале участков кода, в которых ведется работа с файлами.
//
// Параметры:
//   ОписаниеОповещенияОЗакрытии    - ОписаниеОповещения - описание процедуры,
//                                    которая будет вызвана после закрытия формы со следующими параметрами:
//                                      РасширениеПодключено    - Булево - Истина, если расширение было подключено.
//                                      ДополнительныеПараметры - Произвольный - параметры, заданные в
//                                                                               ОписаниеОповещенияОЗакрытии.
//   ТекстПредложения                - Строка - текст сообщения. Если не указан, то выводится текст по умолчанию.
//   ВозможноПродолжениеБезУстановки - Булево - если Истина, будет показана кнопка ПродолжитьБезУстановки,
//                                              если Ложь, будет показана кнопка Отмена.
//
// Пример:
//
//    Оповещение = Новый ОписаниеОповещения("ПечатьДокументаЗавершение", ЭтотОбъект);
//    ТекстСообщения = НСтр("ru = 'Для печати документа необходимо установить расширение работы с файлами.'");
//    ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, ТекстСообщения);
//
//    Процедура ПечатьДокументаЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
//      Если РасширениеПодключено Тогда
//        // код печати документа, рассчитывающий на то, что расширение подключено.
//        // ...
//      Иначе
//        // код печати документа, который работает без подключенного расширения.
//        // ...
//      КонецЕсли;
Процедура ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещенияОЗакрытии, ТекстПредложения = "", ВозможноПродолжениеБезУстановки = Истина) Экспорт
	ОписаниеОповещенияЗавершение = Новый ОписаниеОповещения("ПоказатьВопросОбУстановкеРасширенияРаботыСФайламиЗавершение", ОбщегоНазначенияСлужебныйКлиент, ОписаниеОповещенияОЗакрытии);
	
	#Если Не ВебКлиент Тогда
		// В мобильном, тонком и толстом клиентах расширение подключено всегда.
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияЗавершение, "ПодключениеНеТребуется");
		Возврат;
	#КонецЕсли
	
	ДополнительныеПараметры=Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеОповещенияЗавершение", ОписаниеОповещенияЗавершение);
	ДополнительныеПараметры.Вставить("ТекстПредложения", ТекстПредложения);
	ДополнительныеПараметры.Вставить("ВозможноПродолжениеБезУстановки", ВозможноПродолжениеБезУстановки);
	
	Оповещение=Новый ОписаниеОповещения("ПоказатьВопросОбУстановкеРасширенияРаботыСФайламиПриУстановкеРасширения", ОбщегоНазначенияСлужебныйКлиент, ДополнительныеПараметры);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);	
КонецПроцедуры

// Предлагает пользователю подключить расширение работы с файлами в веб-клиенте,
// и в случае отказа выдает предупреждение о невозможности продолжения операции.
// Предназначена для использования в начале участков кода, в которых ведется работа с файлами
// только при подключенном расширении.
//
// Параметры:
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - описание процедуры, которая будет вызвана, если расширение
//                                                     подключено со следующими параметрами:
//                                                      Результат               - Булево - всегда Истина.
//                                                      ДополнительныеПараметры - Неопределено
//  ТекстПредложения    - Строка - текст с предложением подключить расширение работы с файлами. 
//                                 Если не указан, то выводится текст по умолчанию.
//  ТекстПредупреждения - Строка - текст предупреждения о невозможности продолжения операции. 
//                                 Если не указан, то выводится текст по умолчанию.
//
// Возвращаемое значение:
//  Булево - Истина, если расширение подключено.
//   
// Пример:
//
//    Оповещение = Новый ОписаниеОповещения("ПечатьДокументаЗавершение", ЭтотОбъект);
//    ТекстСообщения = НСтр("ru = 'Для печати документа необходимо установить расширение работы с файлами.'");
//    ОбщегоНазначенияКлиент.ПроверитьРасширениеРаботыСФайламиПодключено(Оповещение, ТекстСообщения);
//
//    Процедура ПечатьДокументаЗавершение(Результат, ДополнительныеПараметры) Экспорт
//        // код печати документа, рассчитывающий на то, что расширение подключено.
//        // ...
Процедура ПроверитьРасширениеРаботыСФайламиПодключено(ОписаниеОповещенияОЗакрытии, Знач ТекстПредложения = "", Знач ТекстПредупреждения = "") Экспорт
	Параметры=Новый Структура("ОписаниеОповещенияОЗакрытии,ТекстПредупреждения", ОписаниеОповещенияОЗакрытии, ТекстПредупреждения, );
	Оповещение=Новый ОписаниеОповещения("ПроверитьРасширениеРаботыСФайламиПодключеноЗавершение", ОбщегоНазначенияСлужебныйКлиент, Параметры);
	ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, ТекстПредложения);	
КонецПроцедуры

// Возвращает пользовательскую настройку "Предлагать установку расширения работы с файлами".
//
// Возвращаемое значение:
//  Булево - Истина, если предлагать.
//
Функция ПредлагатьУстановкуРасширенияРаботыСФайлами() Экспорт
	СистемнаяИнформация=Новый СистемнаяИнформация();
	ИдентификаторКлиента=СистемнаяИнформация.ИдентификаторКлиента;
	Возврат ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("НастройкиПрограммы/ПредлагатьУстановкуРасширенияРаботыСФайлами", ИдентификаторКлиента, Истина);	
КонецФункции





////////////////////////////////////////////////////////////////////////////////
// Клиентские процедуры общего назначения.

// Возвращает текущую дату, приведенную к часовому поясу сеанса.
//
// Функция возвращает время, близкое к результату функции ТекущаяДатаСеанса() в серверном контексте.
// Погрешность обусловлена временем выполнения серверного вызова.
// Предназначена для использования вместо функции ТекущаяДата().
//
Функция ДатаСеанса() Экспорт
	Возврат ТекущаяДата(); // + СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ПоправкаКВремениСеанса;
КонецФункции

// Возвращает универсальную дату сеанса, получаемую из текущей даты сеанса.
//
// Функция возвращает время, близкое к результату функции УниверсальноеВремя() в серверном контексте.
// Погрешность обусловлена временем выполнения серверного вызова.
// Предназначена для использования вместо функции УниверсальноеВремя().
//
Функция ДатаУниверсальная() Экспорт
	Возврат ТекущаяДата();
	//ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	//ДатаСеанса = ТекущаяДата() + ПараметрыРаботыКлиента.ПоправкаКВремениСеанса;
	//Возврат ДатаСеанса + ПараметрыРаботыКлиента.ПоправкаКУниверсальномуВремени;
КонецФункции

// Возвращает Истина, если клиентское приложение подключено к базе через веб-сервер.
//
Функция КлиентПодключенЧерезВебСервер() Экспорт
	Возврат СтрНайти(ВРег(СтрокаСоединенияИнформационнойБазы()), "WS=") = 1;	
КонецФункции

// Функция получает цвет стиля по имени элемента стиля.
//
// Параметры:
//	ИмяЦветаСтиля - строка с именем элемента.
//
// Возвращаемое значение - цвет стиля.
//
Функция ЦветСтиля(ИмяЦветаСтиля) Экспорт
	Возврат ОбщегоНазначенияКлиентПовтИсп.ЦветСтиля(ИмяЦветаСтиля);
КонецФункции

// Функция получает шрифт стиля по имени элемента стиля.
//
// Параметры:
//	ИмяШрифтаСтиля - строка с именем элемента.
//
// Возвращаемое значение - шрифт стиля.
//
Функция ШрифтСтиля(ИмяШрифтаСтиля) Экспорт
	Возврат ОбщегоНазначенияКлиентПовтИсп.ШрифтСтиля(ИмяШрифтаСтиля);	
КонецФункции

// Выполняет переход по ссылке на объект информационной базы или внешний объект.
// (например, ссылка на сайт или путь к папке).
//
// Параметры:
//	Ссылка - Строка - ссылка для перехода.
//
Процедура ПерейтиПоСсылке(Ссылка) Экспорт
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		НачатьЗапускПриложения(, Ссылка);
	#Иначе
		ПерейтиПоНавигационнойСсылке(Ссылка);
	#КонецЕсли	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для обработки событий и вызова необязательных подсистем.

// Возвращает Истина, если "функциональная" подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// У "функциональной" подсистемы снят флажок "Включать в командный интерфейс".
//
// Параметры:
//  ПолноеИмяПодсистемы - Строка - полное имя объекта метаданных подсистема
//                        без слов "Подсистема." и с учетом регистра символов.
//                        Например: "СтандартныеПодсистемы.ВариантыОтчетов".
//
// Пример:
//
//  Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
//  	МодульВариантыОтчетовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВариантыОтчетовКлиент");
//  	МодульВариантыОтчетовКлиент.<Имя метода>();
//  КонецЕсли;
//
// Возвращаемое значение:
//  Булево.
//
Функция ПодсистемаСуществует(ПолноеИмяПодсистемы) Экспорт
	Возврат Ложь;	
КонецФункции

// Возвращает ссылку на общий модуль по имени.
//
// Параметры:
//  Имя          - Строка - имя общего модуля, например:
//                 "ОбщегоНазначения",
//                 "ОбщегоНазначенияКлиент".
//
// Возвращаемое значение:
//  ОбщийМодуль.
//
Функция ОбщийМодуль(Имя) Экспорт
	Модуль=Вычислить(Имя);
	
	#Если НЕ ВебКлиент Тогда
		Если НЕ ТипЗнч(Модуль)=Тип("ОбщийМодуль") Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Общий модуль ""%1"" не найден.'"), Имя);
		КонецЕсли;
	#КонецЕсли

	Возврат Модуль;	
КонецФункции

Функция ОбъектФормыПоЭлементу(Элемент, ТипОбъекта="ФормаКлиентскогоПриложения") Экспорт
	Возврат ?(Тип(Элемент.Родитель)=Тип(ТипОбъекта), Элемент.Родитель, ОбъектФормыПоЭлементу(Элемент.Родитель));
КонецФункции

Функция ФормаПоЭлементу(Элемент) Экспорт
	Возврат ?(Тип(Элемент.Родитель)=Тип("ФормаКлиентскогоПриложения"), Элемент.Родитель, ФормаПоЭлементу(Элемент.Родитель));
КонецФункции