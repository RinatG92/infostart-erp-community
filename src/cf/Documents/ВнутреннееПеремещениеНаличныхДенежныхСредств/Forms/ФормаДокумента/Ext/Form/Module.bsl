﻿////////////////////////////////////////////////////////////////////////////////
// Обработчики событий табличного поля "Вложения"

&НаКлиенте
Процедура тпВложение_ВыполнитьДействие(Команда)
	Если Команда.Имя="ВложенияПредпросмотр" Тогда
		Элементы.ВложенияПредпросмотр.Пометка=НЕ Элементы.ВложенияПредпросмотр.Пометка;
		Элементы.ВложенияГруппаПросмотр.Видимость=Элементы.ВложенияПредпросмотр.Пометка;
		Если Элементы.ВложенияПредпросмотр.Пометка Тогда
			тпВложения_ОбработчикОжидания();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры	 

&НаКлиенте
Процедура тпВложения_ПриАктивизацииСтроки(Элемент)
	Если Элементы.тпВложения.ТекущиеДанные=Неопределено Тогда Возврат; КонецЕсли;
	Если НЕ Элементы.ВложенияПредпросмотр.Пометка Тогда Возврат; КонецЕсли;
	
	тпВложения_ОбработчикОжидания();
КонецПроцедуры

&НаКлиенте
Процедура тпВложения_ПредпросмотПоказать(СтруктураДанных)
	Модуль=ОбщегоНазначенияКлиент.ОбщийМодуль("ВложенияКлиент");
	Модуль.ПредпросмотрПоказать(ЭтаФорма, СтруктураДанных);
КонецПроцедуры

&НаСервере
Процедура тпВложения_ПредпросмотСоздать(СтруктураДанных)
	Модуль=ОбщегоНазначенияСервер.ОбщийМодуль("ВложенияСервер");
	Модуль.ПредпросмотрСоздать(ЭтаФорма, СтруктураДанных);
КонецПроцедуры

&НаКлиенте
Процедура тпВложения_ОбработчикОжидания()
	Если Элементы.тпВложения.ТекущиеДанные=Неопределено Тогда Возврат; КонецЕсли;

	СтруктураДанных=Новый Структура("ИмяФайла,Каталог,ТипID,ID,ВариантХранения,ИндексПиктограммы");
	ЗаполнитьЗначенияСвойств(СтруктураДанных, Элементы.тпВложения.ТекущиеДанные);
	СтруктураДанных.Вставить("Ссылка", Объект.Ссылка);
	СтруктураДанных.Вставить("ИмяРеквизита", ОбщегоНазначенияКлиент.ОбщийМодуль("ВложенияОбщий").ИмяРеквизитаПоИндексуПиктограммы(СтруктураДанных.ИндексПиктограммы));

	Если Элементы.Найти("ВложениеПросмотр"+СтруктураДанных.ИмяРеквизита)=Неопределено Тогда	
		тпВложения_ПредпросмотСоздать(СтруктураДанных);
	КонецЕсли;

	тпВложения_ПредпросмотПоказать(СтруктураДанных);
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Произвольные алгоритмы

&НаКлиенте
Процедура ПримерПроизвольнойКоманды_КнопкаНаФорме()
	СтруктураПараметров=Новый Структура; //***
	
	//Описываем алгоритм выполнения (и место выполнения)
	стрАлгоритм_НаКлиенте="
	|Сообщить(""Код выполнился на клиенте"");
	|ОписаниеОповещения=Новый ОписаниеОповещения(""ВыполнитьАлгоритм_ОбработчикОповещения"", ЭтотОбъект);
	|ПоказатьВводДаты(ОписаниеОповещения,, ""Введите дату дакумента"");
	|";
	
	стрАлгоритм_НаСервере="
	|Сообщить(""Код выполнился на сервере"");
	|";

	стрАлгоритм_НаСервереБезКонтекста="
	|Сообщить(""Код выполнился на сервере без контекста"");
	|";

	СтруктураАлгоритмаВыполнения=Новый Структура;
	СтруктураАлгоритмаВыполнения.Вставить("НаКлиенте", стрАлгоритм_НаКлиенте);
	СтруктураАлгоритмаВыполнения.Вставить("НаСервере", стрАлгоритм_НаСервере);
	СтруктураАлгоритмаВыполнения.Вставить("НаСервереБезКонтекста", стрАлгоритм_НаСервереБезКонтекста);

	//Описываем алгоритм оповещения (и место выполнения)
	стрАлгоритм_НаКлиенте="
	|Сообщить(""Код выполнился на клиенте (оповещение)"");
	|";
	
	стрАлгоритм_НаСервере="
	|Сообщить(""Код выполнился на сервере (оповещение)"");
	|";
	
	стрАлгоритм_НаСервереБезКонтекста="
	|Сообщить(""Код выполнился на сервере без контекста (оповещения)"");
	|";

	СтруктураАлгоритмаОповещения=Новый Структура;
	СтруктураАлгоритмаОповещения.Вставить("НаКлиенте", стрАлгоритм_НаКлиенте);
	СтруктураАлгоритмаОповещения.Вставить("НаСервере", стрАлгоритм_НаСервере);
	СтруктураАлгоритмаОповещения.Вставить("НаСервереБезКонтекста", стрАлгоритм_НаСервереБезКонтекста);

	//Формируем структуру команды
	СтруктураКоманды=Новый Структура;
	СтруктураКоманды.Вставить("АлгоритмВыполнения", СтруктураАлгоритмаВыполнения);
	СтруктураКоманды.Вставить("АлгоритмОповещения", СтруктураАлгоритмаОповещения);
	СтруктураКоманды.Вставить("Имя", "МояСуперКнопка");

	//Создаем (если еще не создана) и формируем структуру произвольных команд
	Если НЕ ТипЗнч(СтруктураПараметров.Форма.ПроизвольныеАлгоритмы)=Тип("Структура") Тогда
		СтруктураПараметров.Форма.ПроизвольныеАлгоритмы=Новый Структура;
	КонецЕсли;
	ПроизвольныеАлгоритмы=СтруктураПараметров.Форма.ПроизвольныеАлгоритмы;
	ПроизвольныеАлгоритмы.Вставить(СтруктураКоманды.Имя, СтруктураКоманды);	

	//Создаем команду
	Команда=СтруктураПараметров.Форма.Команды.Добавить(СтруктураКоманды.Имя);
	Команда.Действие="ВыполнитьАлгоритмКлиент";

	//Создаем кнопку на форме и связываем её с командой
	Кнопка=СтруктураПараметров.Форма.Элементы.Добавить(СтруктураКоманды.Имя, Тип("КнопкаФормы"), СтруктураПараметров.Форма.Элементы.СтраницаТовары);
	Кнопка.ИмяКоманды=СтруктураКоманды.Имя;
	Кнопка.Вид=ВидКнопкиФормы.ОбычнаяКнопка;
КонецПроцедуры
 
&НаКлиенте
Процедура ВыполнитьАлгоритмКлиент(Команда)
	ВыполнитьАлгоритм(Команда.Имя, "АлгоритмВыполнения");
КонецПроцедуры

&НаСервере
Процедура ВыполнитьАлгоритмСервер(Алгоритм, СтруктураКоманды)
	Выполнить(Алгоритм);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВыполнитьАлгоритмСерверБезКонтекста(Алгоритм, СтруктураКоманды)
	Выполнить(Алгоритм);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьАлгоритм_ОбработчикОповещения(Параметр1, Параметр2=Неопределено) Экспорт
	Если Параметр1=Неопределено Тогда Возврат; КонецЕсли;
	ВыполнитьАлгоритм(ЭтаФорма.ТекущийЭлемент.Имя, "АлгоритмОповещения", Параметр1, Параметр2);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьАлгоритм(стрКоманда, стрИмяАлгоритма, Параметр1=Неопределено, Параметр2=Неопределено) Экспорт
	Если НЕ ТипЗнч(ПроизвольныеАлгоритмы)=Тип("Структура") Тогда Возврат; КонецЕсли;

	СтруктураКоманды=Неопределено; ПроизвольныеАлгоритмы.Свойство(стрКоманда, СтруктураКоманды);
	Если НЕ ТипЗнч(СтруктураКоманды)=Тип("Структура") Тогда Возврат; КонецЕсли;

	Для каждого СтрокаКоллекции Из СтруктураКоманды[стрИмяАлгоритма] Цикл
		Если СтрокаКоллекции.Ключ="НаКлиенте" Тогда
			Выполнить(СтрокаКоллекции.Значение);
		ИначеЕсли СтрокаКоллекции.Ключ="НаСервере" Тогда
			ВыполнитьАлгоритмСервер(СтрокаКоллекции.Значение, СтруктураКоманды);
		ИначеЕсли СтрокаКоллекции.Ключ="НаСервереБезКонтекста" Тогда
			ВыполнитьАлгоритмСерверБезКонтекста(СтрокаКоллекции.Значение, СтруктураКоманды);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Обработчики событий атрибутов шапки

&НаКлиенте
Процедура Атрибут_ПриИзменении(Элемент)
	Если Элемент.Имя="Организация" Тогда
		Если НЕ Объект.Организация=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(Объект.Касса, "Владелец") Тогда
			Объект.Касса=ПредопределенноеЗначение("Справочник.Кассы.ПустаяСсылка");
		КонецЕсли;
		Если НЕ Объект.Организация=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(Объект.КассаПолучатель, "Владелец") Тогда
			Объект.КассаПолучатель=ПредопределенноеЗначение("Справочник.Кассы.ПустаяСсылка");
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
			Атрибут_ПриИзменении(Элементы.Организация);
		КонецЕсли;

	ИначеЕсли Элемент.Имя="Касса" Тогда		
		Если ЗначениеЗаполнено(Объект.Касса) И ЗначениеЗаполнено(Объект.КассаПолучатель) Тогда
			ВалютаДенежныхСредствКассаПолучатель=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(Объект.КассаПолучатель, "ВалютаДенежныхСредств");
			ВалютаДенежныхСредствКассаОтправитель=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(Объект.Касса, "ВалютаДенежныхСредств");
			Если НЕ ВалютаДенежныхСредствКассаОтправитель=ВалютаДенежныхСредствКассаПолучатель Тогда
				Сообщить("Разные валюты кассы-отправителя и кассы-получателя.");
				Объект.КассаПолучатель=ПредопределенноеЗначение("Справочник.Кассы.ПустаяСсылка");
			КонецЕсли;
		КонецЕсли;
	    Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
			Объект.Организация=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(Объект.Касса, "Владелец");
		КонецЕсли;

	ИначеЕсли Элемент.Имя="КассаПолучатель" Тогда
		Если ЗначениеЗаполнено(Объект.Касса) И ЗначениеЗаполнено(Объект.КассаПолучатель) Тогда
			ВалютаДенежныхСредствКассаПолучатель=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(Объект.КассаПолучатель, "ВалютаДенежныхСредств");
			ВалютаДенежныхСредствКассаОтправитель=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(Объект.Касса, "ВалютаДенежныхСредств");
			Если НЕ ВалютаДенежныхСредствКассаПолучатель=ВалютаДенежныхСредствКассаОтправитель Тогда
				Сообщить("Разные валюты кассы-отправителя и кассы-получателя.");
				Объект.КассаПолучатель=ПредопределенноеЗначение("Справочник.Кассы.ПустаяСсылка");
			КонецЕсли;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
			Объект.Организация=ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(Объект.КассаПолучатель, "Владелец");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Атрибут_НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Элемент.Имя="КассаПолучатель" Тогда
		МассивПараметров=Новый Массив();
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВалютаДенежныхСредств", ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(Объект.Касса, "ВалютаДенежныхСредств")));
		Элементы.КассаПолучатель.ПараметрыВыбора=Новый ФиксированныйМассив(МассивПараметров);
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура Атрибут_Нажатие(Элемент, СтандартнаяОбработка)
	СобытияЭлементовФормыКлиент.Нажатие(ЭтаФорма, Элемент, СтандартнаяОбработка);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СобытияФормыСервер.ПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СобытияФормыКлиент.ПриОткрытии(Отказ, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	СобытияФормыКлиент.ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	СобытияФормыКлиент.ПриЗакрытии(ЗавершениеРаботы, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	СобытияФормыКлиент.ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	СобытияФормыКлиент.ОбработкаОповещения(ИмяСобытия, Параметр, Источник, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаАктивизации(АктивныйОбъект, Источник)
	СобытияФормыКлиент.ОбработкаАктивизации(АктивныйОбъект, Источник, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	СобытияФормыКлиент.ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка, ЭтаФорма, Объект);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)	
	СобытияФормыСервер.ПриЧтенииНаСервере(ТекущийОбъект, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	СобытияФормыКлиент.ПередЗаписью(Отказ, ПараметрыЗаписи, ЭтаФорма, Объект);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	СобытияФормыСервер.ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи, ЭтаФорма, Объект);
КонецПроцедуры
 
&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	СобытияФормыСервер.ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи, ЭтаФорма, Объект);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	СобытияФормыСервер.ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	СобытияФормыКлиент.ПослеЗаписи(ПараметрыЗаписи, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	СобытияФормыКлиент.ВнешнееСобытие(Источник, Событие, Данные, ЭтаФорма, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ВыборЗначения(СтандартнаяОбработка)
	СобытияФормыКлиент.ВыборЗначения(СтандартнаяОбработка, ЭтаФорма, Объект);
КонецПроцедуры