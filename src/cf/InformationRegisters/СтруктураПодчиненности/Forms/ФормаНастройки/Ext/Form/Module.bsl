﻿&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	Если Команда.Имя="ПрименитьНастройку" Тогда
		ЭтаФорма.Закрыть(мдДерево_СформиоватьЗапрос());
		
	ИначеЕсли Команда.Имя="ПометкиУстановить" Тогда
		мдДерево_ИзменитьИспользование(Истина);
		
	ИначеЕсли Команда.Имя="ПометкиСнять" Тогда
		мдДерево_ИзменитьИспользование(Ложь);
	КонецЕсли; 
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий табичного поля "мдДерево"

&НаСервере
Функция мдДерево_СформиоватьЗапрос()
	дзБуфер=РеквизитФормыВЗначение("мдДерево");
	
	ДанныеПоиска=Новый Массив;
	Для Каждого СтрокаКоллекции Из дзБуфер.Строки Цикл
		Если СтрокаКоллекции.Использование=0 Тогда Продолжить; КонецЕсли;

		МассивРеквизитовШД=Новый Массив;
		Для Каждого СтрокаКоллекции1 Из СтрокаКоллекции.Строки Цикл
			Если СтрокаКоллекции1.Использование=0 Тогда Продолжить; КонецЕсли;

			МассивРеквизитовТЧ=Новый Массив;
			Если СтрокаКоллекции1.Картинка=БиблиотекаКартинок.Таблица Тогда				
				Для Каждого СтрокаКоллекции2 Из СтрокаКоллекции1.Строки Цикл
					Если СтрокаКоллекции2.Использование=0 Тогда Продолжить; КонецЕсли;
					МассивРеквизитовТЧ.Добавить(СтрокаКоллекции2.Идентификатор);
				КонецЦикла;
				Если НЕ МассивРеквизитовТЧ.Количество()=0 Тогда
					ДанныеПоиска.Добавить(Новый Структура("ИмяДокумента, ИмяТабличнойЧасти, ДанныеДокумента", СтрокаКоллекции.Идентификатор, СтрокаКоллекции1.Идентификатор, Новый Структура("ЕстьСумма, ЕстьВалюта, МассивРеквизитов", СтрокаКоллекции.ЕстьРеквизитСумма, СтрокаКоллекции.ЕстьРеквизитВалюта, МассивРеквизитовТЧ)));
				КонецЕсли;				
			Иначе
				МассивРеквизитовШД.Добавить(СтрокаКоллекции1.Идентификатор);	
			КонецЕсли;
		КонецЦикла;
		Если НЕ МассивРеквизитовШД.Количество()=0 Тогда
			ДанныеПоиска.Добавить(Новый Структура("ИмяДокумента, ИмяТабличнойЧасти, ДанныеДокумента", СтрокаКоллекции.Идентификатор, "", Новый Структура("ЕстьСумма, ЕстьВалюта, МассивРеквизитов", СтрокаКоллекции.ЕстьРеквизитСумма, СтрокаКоллекции.ЕстьРеквизитВалюта, МассивРеквизитовШД)));
		КонецЕсли;
	КонецЦикла;
	
	ИмяОбъектаМД=?(Документ.ИмяПредопределенныхДанных="", Документ.ПолноеИмя, Документ.ИмяПредопределенныхДанных);
	ИмяОбъектаМД=стрЗаменить(ИмяОбъектаМД, "Документ.", "ДокументСсылка.");
	ИмяОбъектаМД=стрЗаменить(ИмяОбъектаМД, "Документ_", "ДокументСсылка.");
	ИмяОбъектаМД=стрЗаменить(ИмяОбъектаМД, "Задача.", "ЗадачаСсылка.");
	ИмяОбъектаМД=стрЗаменить(ИмяОбъектаМД, "Задача_", "ЗадачаСсылка.");
	ИмяОбъектаМД=стрЗаменить(ИмяОбъектаМД, "БизнесПроцесс.", "БизнесПроцессСсылка.");
	ИмяОбъектаМД=стрЗаменить(ИмяОбъектаМД, "БизнесПроцесс_", "БизнесПроцессСсылка.");
	//ИмяОбъектаМД=стрЗаменить(ИмяОбъектаМД, "Справочник.", "Справочник.");
	//ИмяОбъектаМД=стрЗаменить(ИмяОбъектаМД, "Справочник_", "Справочник.");

	Попытка ТипОбъекта=Тип(ИмяОбъектаМД);
	Исключение Возврат "";
	КонецПопытки;

	ТекстЗапроса="";
	Для Каждого ЭлементКоллекции Из ДанныеПоиска Цикл
		Для Каждого ИмяРеквизита Из ЭлементКоллекции.ДанныеДокумента.МассивРеквизитов Цикл
			Если НЕ ТекстЗапроса="" Тогда
				ТекстЗапроса=ТекстЗапроса+"
				|ОБЪЕДИНИТЬ ВСЕ
				|";
			КонецЕсли;

			ТекстЗапроса=ТекстЗапроса+"
			|ВЫБРАТЬ
			|	ИсточникДанных.Ссылка КАК Ссылка,
			|	ИсточникДанных.Ссылка.Дата КАК Дата,
			|	ИсточникДанных.Ссылка.ПометкаУдаления КАК ПометкаУдаления,
			|	"+?(Найти(ЭлементКоллекции.ИмяДокумента, "Документ.")=0, "Ложь", "ИсточникДанных.Ссылка.Проведен")+" КАК Проведен,
			|	"+?(ЭлементКоллекции.ДанныеДокумента.ЕстьСумма, "ИсточникДанных.Ссылка.СуммаДокумента", "0")+" КАК Сумма, 
			|	"+?(ЭлементКоллекции.ДанныеДокумента.ЕстьВалюта, "ИсточникДанных.Ссылка.ВалютаДокумента", "ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)")+" КАК Валюта
			|ИЗ
			|	"+ЭлементКоллекции.ИмяДокумента+?(ЭлементКоллекции.ИмяТабличнойЧасти="", "", ".")+ЭлементКоллекции.ИмяТабличнойЧасти+" КАК ИсточникДанных
			|ГДЕ
			|	ИсточникДанных."+ИмяРеквизита+" ССЫЛКА "+стрЗаменить(ИмяОбъектаМД, "Ссылка.", ".")+"
			|	И ИсточникДанных."+ИмяРеквизита+" = &Ссылка
			|";
		КонецЦикла;
	КонецЦикла;
	Возврат ТекстЗапроса;
КонецФункции

&НаСервере
Процедура мдДерево_ИзменитьИспользование(Использование)
	дзБуфер=РеквизитФормыВЗначение("мдДерево");
	дзБуфер.Колонки.Добавить("W", Новый ОписаниеТипов("Число"));

	МассивСтрок=дзБуфер.Строки.НайтиСтроки(Новый Структура("W", 0), Истина);
	Для каждого СтрокаКоллекции Из МассивСтрок Цикл
		СтрокаКоллекции.Использование=Использование;
	КонецЦикла;
	дзБуфер.Колонки.Удалить("W");
	
	ЗначениеВРеквизитФормы(дзБуфер, "мдДерево");
КонецПроцедуры

&НаКлиенте
Процедура мдДерево_ОбновитьСостояниеПометки(Элемент)
	Если Элемент=Неопределено Тогда Возврат; КонецЕсли;

	ЕстьОтмеченные=Ложь; ЕстьНеотмеченные=Ложь;
	Для Каждого ПодчиненныйЭлемент Из Элемент.ПолучитьЭлементы() Цикл
		Если ПодчиненныйЭлемент.Использование Тогда
			ЕстьОтмеченные=Истина;
		Иначе
			ЕстьНеотмеченные=Истина;
		КонецЕсли;
	КонецЦикла;	
	Элемент.Использование=?(ЕстьОтмеченные И ЕстьНеотмеченные, 2, ?(ЕстьОтмеченные, 1, 0));
	мдДерево_ОбновитьСостояниеПометки(Элемент.ПолучитьРодителя());
КонецПроцедуры

&НаКлиенте
Процедура мдДерево_УстановитьПометкуПодчиненным(Элемент)
	Для Каждого ПодчиненнаяСтрока Из Элемент.ПолучитьЭлементы() Цикл
		ПодчиненнаяСтрока.Использование=Элемент.Использование;
		мдДерево_УстановитьПометкуПодчиненным(ПодчиненнаяСтрока);
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Процедура мдДерево_УстановитьПометкуРодителя(СтрокаТабличногоПоля)
	Если СтрокаТабличногоПоля.Родитель=Неопределено Тогда Возврат; КонецЕсли;
	ОбластьПоиска=СтрокаТабличногоПоля.Родитель.Строки;
	
	Есть_0=Не ОбластьПоиска.Найти(0, "Использование")=Неопределено;
	Есть_1=Не ОбластьПоиска.Найти(1, "Использование")=Неопределено;
	Есть_2=Не ОбластьПоиска.Найти(2, "Использование")=Неопределено;
	
	Если Есть_2 Тогда
		СтрокаТабличногоПоля.Родитель.Использование=2;
	ИначеЕсли Есть_0 И Есть_1 Тогда
		СтрокаТабличногоПоля.Родитель.Использование=2;
	ИначеЕсли Есть_0 Тогда
		СтрокаТабличногоПоля.Родитель.Использование=0;
	ИначеЕсли Есть_1 Тогда
		СтрокаТабличногоПоля.Родитель.Использование=1;
	КонецЕсли;
	
	Если НЕ СтрокаТабличногоПоля.Родитель.Родитель=Неопределено Тогда
		мдДерево_УстановитьПометкуРодителя(СтрокаТабличногоПоля.Родитель);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура мдДерево_ПриИзменении(Элемент)
	Если Элемент.ТекущийЭлемент.Имя="мдДеревоПредставление" Тогда
		ТекущиеДанные=Элемент.ТекущиеДанные;
		Если ТекущиеДанные.Использование=2 Тогда
			ТекущиеДанные.Использование=0;
		КонецЕсли;		
		мдДерево_УстановитьПометкуПодчиненным(ТекущиеДанные);				
		мдДерево_ОбновитьСостояниеПометки(ТекущиеДанные.ПолучитьРодителя()); // Изменяем состояние "вверх" (для установки флажков серым)
	КонецЕсли; 
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не Параметры.Свойство("Документ", Документ) Тогда Отказ=Истина; Возврат; КонецЕсли; 
	дзБуфер=РегистрыСведений.СтруктураПодчиненности.СформироватьЗапросПоУмолчанию(Документ, Истина);
	ЗначениеВРеквизитФормы(дзБуфер, "мдДерево");
КонецПроцедуры