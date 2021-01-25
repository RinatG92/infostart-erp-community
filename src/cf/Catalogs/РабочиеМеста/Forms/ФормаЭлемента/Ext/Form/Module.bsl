﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ОтветПередЗаписью;

#КонецОбласти

#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда Возврат; КонецЕсли;

	ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();

	#Если Не ВебКлиент Тогда
	Объект.ИмяКомпьютера = ИмяКомпьютера();
	#КонецЕсли

	Элементы.Оборудование.Доступность = ЗначениеЗаполнено(Объект.Ссылка); 	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ПустаяСтрока(Объект.Код) Тогда
		Объект.Код=ИдентификаторКлиентаКлиент();
	КонецЕсли;	
	МодульМенеджерОборудованияКлиентСервер=ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиентСервер");
	Если НЕ МодульМенеджерОборудованияКлиентСервер=Неопределено Тогда
		МодульМенеджерОборудованияКлиентСервер.ЗаполнитьНаименованиеРабочегоМеста(Объект, ТекущийПользователь);	
	КонецЕсли;		
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	//////Место = ТекущийОбъект.Ссылка;
	//////МодульМенеджерОборудованияВызовСервера=ОбщегоНазначенияСервер.ОбщийМодуль("МенеджерОборудованияВызовСервера");
	//////СписокУстройств = МодульМенеджерОборудованияВызовСервера.ПолучитьСписокОборудования( , , Место);
	//////Для Каждого Элемент Из СписокУстройств Цикл
	//////	Если Элемент.РабочееМесто = Место Тогда
	//////		ЛокальноеОборудование.Добавить(Элемент.Ссылка,Элемент.Наименование, Ложь, ПолучитьКартинку(Элемент.ТипОборудования, 16));
	//////	КонецЕсли;
	//////КонецЦикла	
	
	Место = ТекущийОбъект.Ссылка;
	МодульМенеджерОборудованияВызовСервера=ОбщегоНазначенияСервер.ОбщийМодуль("МенеджерОборудованияВызовСервера");
	Если НЕ МодульМенеджерОборудованияВызовСервера=Неопределено Тогда
		СписокУстройств = МодульМенеджерОборудованияВызовСервера.ОборудованиеПоПараметрам( , , Место);
		Для Каждого Элемент Из СписокУстройств Цикл
			Если Элемент.РабочееМесто=Место Тогда
				ЛокальноеОборудование.Добавить(Элемент.Ссылка,Элемент.Наименование, Ложь, ПолучитьКартинку(Элемент.ТипОборудования, 16));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ПроверкаУникальностиПоИдентификаторуКлиента()Тогда
		Текст = НСтр("ru='Ошибка сохранение рабочего места.
					|Рабочее место с таким идентификатором клиента уже существует.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
		Отказ = Истина; Возврат;
	КонецЕсли;
	
	Если Не ПроверкаУникальностиПоНаименованию()Тогда
		Если ОтветПередЗаписью <> Истина Тогда
			Отказ = Истина;
			Текст = НСтр("ru='Указано неуникальное наименование рабочего места.
						|Возможно в дальнейшем это затруднит идентификацию и выбор рабочего места.
						|Рекомендуется указывать уникальное наименование рабочих мест.
						|Продолжить сохранение с указанным наименованием?'");
			Оповещение = Новый ОписаниеОповещения("ПередЗаписьюЗавершение", ЭтотОбъект);
			ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюЗавершение(Результат, Параметры) Экспорт
	Если Результат=КодВозвратаДиалога.Да Тогда
		ОтветПередЗаписью=Истина; Записать();
	КонецЕсли;  	
КонецПроцедуры 
   
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Если Объект.Код=ИдентификаторКлиентаКлиент() Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	МодульМенеджерОборудованияКлиентСервер=ОбщегоНазначенияКлиент.ОбщийМодуль("МенеджерОборудованияКлиентСервер");
	МодульМенеджерОборудованияКлиентСервер.ЗаполнитьНаименованиеРабочегоМеста(Объект, ТекущийПользователь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПроверкаУникальностиПоНаименованию()
	Если ПустаяСтрока(Объект.Наименование) Тогда Возврат Истина; КонецЕсли;
	
	Запрос=Новый Запрос;
	Запрос.УстановитьПараметр("Наименование", Объект.Наименование);
	Запрос.УстановитьПараметр("Ссылка"      , Объект.Ссылка);
	Запрос.Текст="
	|ВЫБРАТЬ
	|    1
	|ИЗ
	|    Справочник.РабочиеМеста КАК РабочиеМеста
	|ГДЕ
	|    РабочиеМеста.Наименование = &Наименование И РабочиеМеста.Ссылка <> &Ссылка
	|";
	Возврат Запрос.Выполнить().Пустой();
КонецФункции

&НаСервере
Функция ИдентификаторКлиентаСервер()
	СистемнаяИнформация=Новый СистемнаяИнформация();
	Возврат ВРег(СистемнаяИнформация.ИдентификаторКлиента);	
КонецФункции

&НаКлиенте
Функция ИдентификаторКлиентаКлиент()
	СистемнаяИнформация=Новый СистемнаяИнформация();
	Возврат ВРег(СистемнаяИнформация.ИдентификаторКлиента);	
КонецФункции

&НаСервере
Функция ПроверкаУникальностиПоИдентификаторуКлиента()
	Если ПустаяСтрока(Объект.Код) Тогда Возврат Истина; КонецЕсли;

	Запрос=Новый Запрос;
	Запрос.УстановитьПараметр("Код", ИдентификаторКлиентаСервер());
	Запрос.УстановитьПараметр("Ссылка" , Объект.Ссылка);	
	Запрос.Текст="
	|ВЫБРАТЬ
	|    1
	|ИЗ
	|    Справочник.РабочиеМеста КАК РабочиеМеста
	|ГДЕ
	|    РабочиеМеста.Код = &Код И РабочиеМеста.Ссылка <> &Ссылка
	|";	
	Возврат Запрос.Выполнить().Пустой();
КонецФункции

&НаСервере
Функция ПолучитьКартинку(ТипОборудования, Размер)
	Попытка // Может прийти пустая ссылка или неопределено, может не быть картинки.
		МетаОбъект  = ТипОборудования.Метаданные();
		Индекс      = Перечисления.ТипыПодключаемогоОборудования.Индекс(ТипОборудования);
		ИмяКартинки = МетаОбъект.ЗначенияПеречисления[Индекс].Имя;
		ИмяКартинки = "ПодключаемоеОборудование" + ИмяКартинки + Размер;
		Картинка = БиблиотекаКартинок[ИмяКартинки]
	Исключение
		Картинка = Неопределено;
	КонецПопытки;
	
	Возврат Картинка;	
КонецФункции

#КонецОбласти