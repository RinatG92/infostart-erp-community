﻿&НаСервереБезКонтекста
Функция НайтиСсылкуПоКоду(КодЧисловой)
	Возврат Справочники.КлассификаторОКОПФ.НайтиПоКоду(КодЧисловой);
КонецФункции

&НаСервереБезКонтекста
Процедура СоздатьНовыйЭлемент(СтруктураПараметров)
	СправочникОбъект=Справочники.КлассификаторОКОПФ.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(СправочникОбъект, СтруктураПараметров);
	СправочникОбъект.Записать();	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОповешения_ОтветНаВопрос(Параметр1, Параметр2) Экспорт
	Если НЕ Параметр1=КодВозвратаДиалога.Да Тогда Возврат; КонецЕсли;
	СоздатьНовыйЭлемент(Параметр2);	
	ВладелецФормы.Элементы.ДинамическийСписок.Обновить();
КонецПроцедуры

&НаСервере
Процедура ТабличноеПоле_Инициализация()
	Макет=Справочники.КлассификаторОКОПФ.ПолучитьМакет("КлассификаторОКОПФ");
	Макет.Параметры.Расшифровка=Истина; // чтобы работала расшифровка

	ПолеТабличногоДокумента.Очистить();
	ПолеТабличногоДокумента.Вывести(Макет);

	ПолеТабличногоДокумента.ФиксацияСверху=3;	
	ПолеТабличногоДокумента.ОтображатьЗаголовки=Ложь;
	ПолеТабличногоДокумента.ОтображатьСетку=Ложь;
	ПолеТабличногоДокумента.ТолькоПросмотр=Истина;
КонецПроцедуры
 
&НаКлиенте
Процедура ТабличноеПоле_ОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;	
	ТекущаяОбласть=ПолеТабличногоДокумента.ТекущаяОбласть;		
	Если ТекущаяОбласть.Низ=ТекущаяОбласть.Верх Тогда
		КодЧисловой=ПолеТабличногоДокумента.Область(ТекущаяОбласть.Низ, 2).Текст;
		Если Не ЗначениеЗаполнено(КодЧисловой) Тогда Возврат; КонецЕсли; 

		СтруктураПараметров=Новый Структура;
		СтруктураПараметров.Вставить("Ключ", НайтиСсылкуПоКоду(КодЧисловой));

		Если СтруктураПараметров.Ключ.Пустая() Тогда
			СтруктураПараметров.Вставить("Код", КодЧисловой);
			СтруктураПараметров.Вставить("НаименованиеПолное", ПолеТабличногоДокумента.Область(ТекущаяОбласть.Низ, 3).Текст);
			СтруктураПараметров.Вставить("Наименование", ПолеТабличногоДокумента.Область(ТекущаяОбласть.Низ, 4).Текст);
			Если ПустаяСтрока(СтруктураПараметров.Наименование) Тогда
				СтруктураПараметров.Наименование=СтруктураПараметров.НаименованиеПолное;
			КонецЕсли;
			ОписаниеОповещения=Новый ОписаниеОповещения("ОбработчикОповешения_ОтветНаВопрос", ЭтотОбъект, СтруктураПараметров);
			стрВопрос="Записать в справочник ""Классификатор ОКОПФ"" элемент с наименование """+СтруктураПараметров.НаименованиеПолное+"""?";
			ПоказатьВопрос(ОписаниеОповещения, стрВопрос, РежимДиалогаВопрос.ДаНет, 20, КодВозвратаДиалога.Нет, "Внимание", КодВозвратаДиалога.Нет);
		Иначе
			ОткрытьФорму("Справочник.КлассификаторОКОПФ.Форма.ФормаЭлемента", СтруктураПараметров, ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;				
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТабличноеПоле_Инициализация();
КонецПроцедуры
