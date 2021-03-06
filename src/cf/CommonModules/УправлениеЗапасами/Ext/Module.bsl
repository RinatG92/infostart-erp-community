﻿// Формирует структуру дерева значений, содержащего имена полей, которые
// нужно заполнить в запросе по шапке документа.
//
// Возвращаемое значение:
//  Дерево значений.
//
Функция СформироватьДеревоПолейЗапросаПоШапке() Экспорт
	
	ОписаниеТиповСтрока = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(100);

	ДеревоПолейЗапросаПоШапке=Новый ДеревоЗначений;	
	ДеревоПолейЗапросаПоШапке.Колонки.Добавить("Объект"   , ОписаниеТиповСтрока);
	ДеревоПолейЗапросаПоШапке.Колонки.Добавить("Поле"     , ОписаниеТиповСтрока);
	ДеревоПолейЗапросаПоШапке.Колонки.Добавить("Псевдоним", ОписаниеТиповСтрока);

	Возврат ДеревоПолейЗапросаПоШапке;

КонецФункции

// Вставляет строку в дерево полей запроса по шапке, если ее там еще нет,
// если есть, то ничего не делает.
//
// Параметры:
//  ДеревоПолейЗапросаПоШапке - дерево значений, содержащего имена полей, 
//                              которые нужно заполнить в запросе по шапке документа, 
//  ИмяОбъекта                - строка, имя объекта (справочник, регистр и т.д.), 
//  ИмяПоля                   - строка, имя поля объекта,
//  ИмяПсевдонима             - строка, имя псевдонима в запросе поля объекта (необязательный).
//
Процедура ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, ИмяОбъекта, ИмяПоля, ИмяПсевдонима = Неопределено) Экспорт

	// Поищем нужную строку.
	// Вначале ищем объект.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти(ИмяОбъекта, "Объект");

	Если СтрокаОбъекта = Неопределено Тогда // нужно добавить.
		СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Добавить();
		СтрокаОбъекта.Объект    = ИмяОбъекта;
		СтрокаОбъекта.Поле      = ИмяПоля;
		СтрокаОбъекта.Псевдоним = ИмяПсевдонима;
	КонецЕсли;

	// Ищем поле.
	СтрокаПоля = СтрокаОбъекта.Строки. Найти(ИмяПоля,"Поле");

	Если СтрокаПоля = Неопределено Тогда // нужно добавить
		СтрокаПоля = СтрокаОбъекта.Строки.Добавить();
		СтрокаПоля.Поле      = ИмяПоля;
		СтрокаПоля.Псевдоним = ИмяПсевдонима;
	КонецЕсли;

	// Ищем псевдоним.
	СтрокаПоля = СтрокаОбъекта.Строки.Найти( ИмяПсевдонима, "Псевдоним");

	Если СтрокаПоля = Неопределено Тогда // нужно добавить
		СтрокаПоля = СтрокаОбъекта.Строки.Добавить();
		СтрокаПоля.Поле      = ИмяПоля;
		СтрокаПоля.Псевдоним = ИмяПсевдонима;
	КонецЕсли;

КонецПроцедуры

// Формирует запрос на дополнительные параметры, нужные при проведении документа.
//
// Параметры: 
//  ДокументОбъект                 - объект проводимого документа, 
//  ДеревоПолейЗапросаПоШапке      - дерево значений, содержащего имена полей, 
//                                   которые нужно заполнить в запросе по шапке документа.
//  СтруктураШапкиДокумента        - структура, содержащая значения реквизитов, относящихся к шапке документа,
//                                   необходимых для его проведения.
//  ВалютаРегламентированногоУчета - валюта регламентированного учета
//
// Возвращаемое значение:
//  Дополненная по результату запроса структура СтруктураШапкиДокумента.
//
Функция СформироватьЗапросПоДеревуПолей(ДокументОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, ВалютаРегламентированногоУчета)  Экспорт

	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ ";

	СтрокиЗапроса           = "";
	ТаблицыЗапроса          = "";
	НуженКурсВалютыУпрУчета = Ложь;
	ЕстьУчетнаяПолитика     = Ложь;
	
	ДокументОбъектМетаданные = ДокументОбъект.Метаданные();	
	
	// Реквизиты договора взаиморасчетов.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ДоговорыКонтрагентов", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ДоговорКонтрагента." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты договора взаиморасчетов регл.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ДоговорыКонтрагентовРегл", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ДоговорКонтрагентаРегл." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты организации.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("Организации", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.Организация." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты сделки.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("Сделка", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		Если ЗначениеЗаполнено(ДокументОбъект.Сделка) Тогда
			СделкаМетаданные = ДокументОбъект.Сделка.Метаданные();
		Иначе
			СделкаМетаданные = Неопределено;
		КонецЕсли;
		
		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + ?(СделкаМетаданные = Неопределено ИЛИ СделкаМетаданные.Реквизиты.Найти(СокрЛП(СтрокаПоля.Поле)) = Неопределено,
								"NULL",
								"ВЫРАЗИТЬ(Док.Сделка КАК Документ." + СделкаМетаданные.Имя + ")." + СокрЛП(СтрокаПоля.Поле)) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты расчетного документа.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("РасчетныйДокумент", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		Если ЗначениеЗаполнено(ДокументОбъект.РасчетныйДокумент) Тогда
			СделкаМетаданные = ДокументОбъект.РасчетныйДокумент.Метаданные();
		Иначе
			СделкаМетаданные = Неопределено;
		КонецЕсли;
		
		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + ?(СделкаМетаданные = Неопределено, "NULL", "ВЫРАЗИТЬ(Док.РасчетныйДокумент КАК Документ." + СделкаМетаданные.Имя + ")." + СокрЛП(СтрокаПоля.Поле)) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты склада.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("Склад", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.Склад." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	//////////// Реквизиты склада-группы.
	//////////СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("Склад", "Объект");
	//////////Если СтрокаОбъекта <> Неопределено Тогда

	//////////	// В цикле по вложенным строкам формируем строки запроса.
	//////////	Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

	//////////		СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
	//////////		Символы.Таб + "Док.Склад." + СокрЛП(СтрокаПоля.Поле) +
	//////////		?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

	//////////	КонецЦикла;

	//////////КонецЕсли;  //14.08.2012
	
	// Реквизиты склада-отправителя
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("СкладОтправитель", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.СкладОтправитель." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты склада-отправителя
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ДокументПеремещения", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ДокументПеремещения." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты склада-отправителя
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ДокументПередачи", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ДокументПередачи." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты склада-получателя
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("СкладПолучатель", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.СкладПолучатель." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты склада-ордера
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("Склад", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.Склад." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("Заказ", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.Заказ." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ВнутреннийЗаказ", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ВнутреннийЗаказ." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты заказа покупателя
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ЗаказПокупателя", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ЗаказПокупателя." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Реквизиты заказа поставщику
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ЗаказПоставщику", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ЗаказПоставщику." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;

	// Реквизиты номенклатуры
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("Номенклатура", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.Номенклатура." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;

	// Реквизиты документа основания
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("ДокументОснование", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "Док.ДокументОснование." + СокрЛП(СтрокаПоля.Поле) +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Пустые реквизиты.
	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("NULL", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
			Символы.Таб + "NULL" +
			?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

		КонецЦикла;

	КонецЕсли;
	
	// Константы.
	ТаблицыЗапроса = ТаблицыЗапроса + ", Константы";

	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("Константы", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда

		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл

			Если СтрокаПоля.Поле = "КурсВалютыУправленческогоУчета" Тогда

				СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
				Символы.Таб + "КурсыВалютСрезПоследних.Курс КАК КурсВалютыУправленческогоУчета";
			
				СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
				Символы.Таб + "КурсыВалютСрезПоследних.Кратность КАК КратностьВалютыУправленческогоУчета";
			
				НуженКурсВалютыУпрУчета = Истина;

			Иначе

				СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС +
				Символы.Таб + "Константы." + СокрЛП(СтрокаПоля.Поле) +
				?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));

			КонецЕсли;

		КонецЦикла;

	КонецЕсли;

	СтрокаОбъекта = ДеревоПолейЗапросаПоШапке.Строки.Найти("УчетнаяПолитика", "Объект");
	Если СтрокаОбъекта <> Неопределено Тогда
		ЕстьУчетнаяПолитика = Истина;
		
		// В цикле по вложенным строкам формируем строки запроса.
		Для Каждого СтрокаПоля Из СтрокаОбъекта.Строки Цикл
			СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС + 
			Символы.Таб + "УчетнаяПолитикаСрезПоследних." + СокрЛП(СтрокаПоля.Поле) +
				?(НЕ ЗначениеЗаполнено(СтрокаПоля.Псевдоним), "", " КАК " + СокрЛП(СтрокаПоля.Псевдоним));
		КонецЦикла;
			
	КонецЕсли;

	// Надо добавить константу ВалютаРегламнтированногоУчета
	СтрокиЗапроса = СтрокиЗапроса + "," + Символы.ПС + 
	Символы.Таб + "Константы.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета";

	СтрокаЗапросаКурсВалютыУпрУчета = Символы.ПС + "
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&ДатаДокумента,) КАК КурсыВалютСрезПоследних
	|	ПО Константы.ВалютаУправленческогоУчета = КурсыВалютСрезПоследних.Валюта";

	СтрокаРегистраУчетнойПолитики = Символы.ПС + "
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитика.СрезПоследних(&ДатаДокумента, Организация=&Организация) КАК УчетнаяПолитикаСрезПоследних
	|	ПО Истина";
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ "+Сред(СтрокиЗапроса, 2)+"
				| ИЗ 
	            |	Документ." + ДокументОбъектМетаданные.Имя + " КАК Док "+ ТаблицыЗапроса +
	            ?(НуженКурсВалютыУпрУчета, СтрокаЗапросаКурсВалютыУпрУчета,"") + Символы.ПС + 
	            ?(ЕстьУчетнаяПолитика, СтрокаРегистраУчетнойПолитики,"") + Символы.ПС + "
	            |	ГДЕ Док.Ссылка = &ДокументСсылка";
					
	Организация=Неопределено; СтруктураШапкиДокумента.Свойство("Организация", Организация);

	// Установим параметры запроса.
	Запрос.УстановитьПараметр("Организация" , ?(Организация=Неопределено, Справочники.Организации.ПустаяСсылка(), Организация));
	Запрос.УстановитьПараметр("ДокументСсылка" , ДокументОбъект.Ссылка);
	Запрос.УстановитьПараметр("ДатаДокумента"  , ?(УправлениеМетаданными.ЕстьРеквизит("ПериодРегистрации", ДокументОбъектМетаданные), КонецМесяца(ДокументОбъект.ПериодРегистрации), ДокументОбъект.Дата));

	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();

	Для Каждого Колонка из ТаблицаЗапроса.Колонки Цикл
		Если ТаблицаЗапроса.Количество() = 0 Тогда
			СтруктураШапкиДокумента.Вставить(Колонка.Имя, Неопределено);
		Иначе
			СтруктураШапкиДокумента.Вставить(Колонка.Имя, ТаблицаЗапроса[0][Колонка.Имя]);
		КонецЕсли;
	КонецЦикла;
	
	Если СтруктураШапкиДокумента.Свойство("ВалютаДокумента") Тогда
		Если УправлениеМетаданными.ЕстьРеквизит("ВалютаДокумента", ДокументОбъектМетаданные) Тогда
			СтруктураШапкиДокумента.Вставить("КурсДокумента", ЗаполнениеДокументов.КурсДокумента(ДокументОбъект, ВалютаРегламентированногоУчета));
			СтруктураШапкиДокумента.Вставить("КратностьДокумента", ЗаполнениеДокументов.КратностьДокумента(ДокументОбъект, ВалютаРегламентированногоУчета));
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтруктураШапкиДокумента;
	
КонецФункции

Процедура КорректировкаМассиваОбязательныхПолей(ДокументОбъект, ИмяТабличнойЧасти, МассивОбязательныхПолей, ВидСклада=Неопределено) Экспорт
	РазрешитьПустыеПоля=Ложь;
	Если ВидСклада = Перечисления.ВидыСкладов.Оптовый Или НЕ ЗначениеЗаполнено(ВидСклада) Тогда
		РазрешитьПустыеПоля = УправлениеПользователямиСервер.РазрешитьНулевыеЦеныВОпте();
	ИначеЕсли ВидСклада = Перечисления.ВидыСкладов.Розничный Тогда
		РазрешитьПустыеПоля = УправлениеПользователямиСервер.РазрешитьНулевыеЦеныВРознице();
	КонецЕсли;

	Если РазрешитьПустыеПоля Тогда
		Индекс=МассивОбязательныхПолей.Найти(ИмяТабличнойЧасти+".Сумма");
		Если Не Индекс=Неопределено Тогда МассивОбязательныхПолей.Удалить(Индекс); КонецЕсли;

		Индекс=МассивОбязательныхПолей.Найти(ИмяТабличнойЧасти+".Цена");
		Если Не Индекс=Неопределено Тогда МассивОбязательныхПолей.Удалить(Индекс); КонецЕсли;
		
		Индекс=МассивОбязательныхПолей.Найти(ИмяТабличнойЧасти+".ЦенаВРознице");
		Если Не Индекс=Неопределено Тогда МассивОбязательныхПолей.Удалить(Индекс); КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// По переданной структуре полей формирует запрос по табличной части документа.
//
// Параметры: 
//  ДокументОбъект        - объект проводимого документа, 
//  ИмяТабличнойЧасти     - строка, имя табличной части,
//  СтруктураПолей        - структура, ключ структуры содержит псевдоним поля запроса, значение - строку запроса,
//  СтруктураСложныхПолей - структура, ключ структуры содержит псевдоним поля запроса, значение - строку запроса,
//                          необязательный параметр, служит для передачи конструкций типа "ВЫБОР" и т.д.
//
// Возвращаемое значение:
//  Результат запроса.
//
Функция СформироватьЗапросПоТабличнойЧасти(ДокументОбъект, ИмяТабличнойЧасти, СтруктураПолей, СтруктураСложныхПолей=Неопределено) Экспорт

	ТекстЗапроса=""; ТекстСоединение=""; ДокументМетаданные=ДокументОбъект.Метаданные();

	Если Не СтруктураПолей.Свойство("Организация") Тогда
		Если УправлениеМетаданными.ЕстьРеквизит("Организация", ДокументМетаданные) Тогда
			СтруктураПолей.Вставить("Организация", "Ссылка.Организация");
		КонецЕсли;
	КонецЕсли;

	Если Не СтруктураПолей.Свойство("НомерСтрокиТабличнойЧасти") Тогда
		СтруктураПолей.Вставить("НомерСтрокиТабличнойЧасти", "НомерСтроки");
	КонецЕсли;

	Для Каждого Реквизит Из СтруктураПолей Цикл
		стрКлюч=СокрЛП(Реквизит.Ключ);
		Если стрКлюч="ВидТабличнойЧасти" Тогда
			ТекстЗапроса=ТекстЗапроса+",
			|"""+Реквизит.Значение+""" КАК "+стрКлюч;
		Иначе
			ТекстЗапроса=ТекстЗапроса+",
			|Док."+Реквизит.Значение+" КАК "+стрКлюч;			
		КонецЕсли;	 
	КонецЦикла;
	
	Запрос=Новый Запрос;
	Запрос.УстановитьПараметр("Активность" , Истина);
	Запрос.УстановитьПараметр("ДокументСсылка" , ДокументОбъект.Ссылка);

	Если ТипЗнч(СтруктураСложныхПолей) = Тип("Структура") Тогда // Добавим к запросу конструкции.
		Для Каждого Элемент Из СтруктураСложныхПолей Цикл
			ТекстЗапроса=ТекстЗапроса+", "+Элемент.Значение+" КАК "+СокрЛП(Элемент.Ключ);
		КонецЦикла;
	КонецЕсли;
		
	Запрос.Текст="
	|ВЫБРАТЬ 
	|	&Активность,
	|	Док.НомерСтроки "+ТекстЗапроса+"
	|ИЗ
	|	Документ."+ДокументМетаданные.Имя+"."+СокрЛП(ИмяТабличнойЧасти)+" КАК Док"+ТекстСоединение+" 
	|ГДЕ Док.Ссылка = &ДокументСсылка
	|УПОРЯДОЧИТЬ ПО НомерСтроки
	|";

	Если ДокументОбъект[ИмяТабличнойЧасти].Количество() = 0 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ГДЕ Док.Ссылка = &ДокументСсылка", "ГДЕ ЛОЖЬ");
	КонецЕсли;

	Возврат Запрос.Выполнить();
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБСЛУЖИВАНИЯ КОМПЛЕКТУЮЩИХ

// Формирует копию таблицы значений, с заменой "комплекта" на "комплектующие".
//
// Параметры:
//  ТаблицаИсточник         - таблица значений источник, содержащая комплекты,
//  ДокументОбъект          – объект редактируемого документа,
//  СтруктураШапкиДокумента - структура шапки документа.
//
// Возвращаемое значение:
//  Таблица значений.
//
Функция СформироватьТаблицуКомплектующих(ТаблицаИсточник, ДокументОбъект, СтруктураШапкиДокумента = Неопределено) Экспорт
	Если ТаблицаИсточник.Количество()=0 Тогда
		Возврат ТаблицаИсточник.Скопировать();
	КонецЕсли; 

	ТаблицаРезультат=ТаблицаИсточник.Скопировать();
	ТаблицаРезультат.Колонки.Добавить("НоменклатураКомплекта");
	ТаблицаРезультат.Колонки.Добавить("ХарактеристикаКомплекта");
	ТаблицаРезультат.Колонки.Добавить("КоличествоКомплекта");
	ТаблицаРезультат.Индексы.Добавить("Комплект");

	ЕстьНомерСтрокиТабличнойЧасти=НЕ ТаблицаРезультат.Колонки.Найти("НомерСтрокиТабличнойЧасти")=Неопределено;
	ЕстьВидТабличнойЧасти=НЕ ТаблицаРезультат.Колонки.Найти("ВидТабличнойЧасти")=Неопределено;
	
	НайденныеКомплекты = ТаблицаРезультат.НайтиСтроки(Новый Структура("Комплект", Истина));
	Если НайденныеКомплекты.Количество() > 0 Тогда
		МетаданныеДокумента = ДокументОбъект.Метаданные();
		ИмяДокумента        = МетаданныеДокумента.Имя;
		ЕстьСерия           = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("СерияНоменклатуры",            МетаданныеДокумента, "СоставНабора");
		ЕстьСклад           = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("Склад",                        МетаданныеДокумента, "СоставНабора");
		ЕстьКачество        = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("Качество",                     МетаданныеДокумента, "СоставНабора");
		ЕстьСпособСписания  = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("СпособСписанияОстаткаТоваров", МетаданныеДокумента, "СоставНабора");
		ЕстьСебестоимость   = ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("Себестоимость",                МетаданныеДокумента, "СоставНабора");

		СписокКомплектов = Новый СписокЗначений;
		Для Каждого СтрокаКомплект Из НайденныеКомплекты Цикл
			СписокКомплектов.Добавить(СтрокаКомплект.ID);
		КонецЦикла;

		Запрос=Новый Запрос;
		Запрос.УстановитьПараметр("ПарДокументСсылка",   ДокументОбъект.Ссылка);
		Запрос.УстановитьПараметр("ПарСписокКомплектов", СписокКомплектов);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Док.НомерСтроки                                          КАК НомерСтрокиТабличнойЧасти,
		|	Док.ID_Товары                                            КАК ID_Товары,
		|	Док.Номенклатура                                         КАК Номенклатура,
		|	Док.Номенклатура.ВестиПартионныйУчетПоСериям             КАК ВестиПартионныйУчетПоСериям,
		|	Док.ХарактеристикаНоменклатуры                           КАК ХарактеристикаНоменклатуры,
		|" + ?(ЕстьСерия,          "Док.СерияНоменклатуры            КАК СерияНоменклатуры,",            "") + "
		|" + ?(ЕстьСклад,          "Док.Склад                        КАК Склад,
		|						    Док.Склад.ВидСклада              КАК ВидСклада,",                    "") + "
		|" + ?(ЕстьКачество,       "Док.Качество                     КАК Качество,",                     "") + "
		|" + ?(ЕстьСпособСписания, "Док.СпособСписанияОстаткаТоваров КАК СпособСписанияОстаткаТоваров,", "") + "
		|" + ?(ЕстьСебестоимость,  "Док.Себестоимость                КАК Себестоимость,",                "") + "
		|	Док.Количество                                           КАК Количество,
		|	Док.Количество * 
		|		Док.ЕдиницаИзмерения.Коэффициент /
		|		Док.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КоличествоХранения,
		|	Док.ЕдиницаИзмерения                                     КАК ЕдиницаИзмерения,
		|	Док.Цена                                     			 КАК Цена
		|
		|ИЗ
		|	Документ."+ИмяДокумента+".СоставНабора КАК Док
		|
		|ГДЕ
		|	Док.Ссылка = &ПарДокументСсылка
		|	И Док.ID_Товары В (&ПарСписокКомплектов)
		|
		|";
		ТаблицаКомплектующих=Запрос.Выполнить().Выгрузить();
		ТаблицаКомплектующих.Индексы.Добавить("ID_Товары");

        КолекцияРаспределяемыхПоказателей=Новый Структура("Цена", 0);		
		Для Каждого СтрокаКомплект Из НайденныеКомплекты Цикл
			НайденныеКомплектующие=ТаблицаКомплектующих.НайтиСтроки(Новый Структура("ID_Товары", СтрокаКомплект.ID));
			
			БазаЦены = 0;
			Для Каждого СтрокаКомплектующая Из НайденныеКомплектующие Цикл
				БазаЦены = БазаЦены + СтрокаКомплектующая.Цена;
			КонецЦикла;
			//*** Если БазаЦены=0 Тогда БазаЦены=СтрокаКомплект.Цена; КонецЕсли; //23.05.2016
			Если НЕ ТаблицаРезультат.Колонки.Найти("Количество") = Неопределено Тогда
				КоличествоКомплекта = СтрокаКомплект.Количество;
			Иначе
				КоличествоКомплекта = СтрокаКомплект.КоличествоДок;
			КонецЕсли;	
			КолекцияРаспределяемыхПоказателей = Новый Структура("Цена", 0);
			РапределеноЦены	= 0;
			
			Для Каждого СтрокаКомплектующая Из НайденныеКомплектующие Цикл
				НоваяСтрока=ТаблицаРезультат.Добавить();
							
				Для Сч = 1 По ТаблицаРезультат.Колонки.Количество() Цикл
					Индекс     = Сч - 1;
					ИмяКолонки = ТаблицаРезультат.Колонки[Индекс].Имя;

					Если ИмяКолонки = "ДокументПартии"                ИЛИ
					     ИмяКолонки = "ДокументПолучения"             ИЛИ
					     ИмяКолонки = "ОрганизацияДокументаПолучения" ИЛИ
					     ИмяКолонки = "НомерСтроки"                   ИЛИ
					     ИмяКолонки = "Услуга"                        ИЛИ
					     ИмяКолонки = "Набор"                         Тогда
						НоваяСтрока.Установить(Индекс, СтрокаКомплект.Получить(Индекс));

					ИначеЕсли ИмяКолонки = "СерияНоменклатуры" И ЕстьСерия Тогда
						Если НЕ ЗначениеЗаполнено(СтрокаКомплектующая.СерияНоменклатуры) Тогда
							НоваяСтрока.Установить(Индекс, СтрокаКомплект.Получить(Индекс));
						Иначе
							НоваяСтрока.Установить(Индекс, СтрокаКомплектующая.СерияНоменклатуры);
						КонецЕсли;

					ИначеЕсли ИмяКолонки = "Склад" И ЕстьСклад Тогда
						Если НЕ ЗначениеЗаполнено(СтрокаКомплектующая.Склад) Тогда
							НоваяСтрока.Установить(Индекс, СтрокаКомплект.Получить(Индекс));
						Иначе
							НоваяСтрока.Установить(Индекс, СтрокаКомплектующая.Склад);
						КонецЕсли;

					ИначеЕсли ИмяКолонки = "ВидСклада" И ЕстьСклад Тогда
						Если НЕ ЗначениеЗаполнено(СтрокаКомплектующая.ВидСклада) Тогда
							НоваяСтрока.Установить(Индекс, СтрокаКомплект.Получить(Индекс));
						Иначе
							НоваяСтрока.Установить(Индекс, СтрокаКомплектующая.ВидСклада);
						КонецЕсли;

					ИначеЕсли ИмяКолонки = "Качество" И ЕстьКачество Тогда
						Если НЕ ЗначениеЗаполнено(СтрокаКомплектующая.Качество) Тогда
							НоваяСтрока.Установить(Индекс, СтрокаКомплект.Получить(Индекс));
						Иначе
							НоваяСтрока.Установить(Индекс, СтрокаКомплектующая.Качество);
						КонецЕсли;

					ИначеЕсли ИмяКолонки = "СпособСписанияОстаткаТоваров" И ЕстьСпособСписания Тогда
						Если НЕ ЗначениеЗаполнено(СтрокаКомплектующая.СпособСписанияОстаткаТоваров) Тогда
							НоваяСтрока.Установить(Индекс, СтрокаКомплект.Получить(Индекс));
						Иначе
							НоваяСтрока.Установить(Индекс, СтрокаКомплектующая.СпособСписанияОстаткаТоваров);
						КонецЕсли;

					ИначеЕсли ИмяКолонки = "Номенклатура" Тогда
						НоваяСтрока.Установить(Индекс, СтрокаКомплектующая.Номенклатура);

					ИначеЕсли ИмяКолонки = "ХарактеристикаНоменклатуры" Тогда
						НоваяСтрока.Установить(Индекс, СтрокаКомплектующая.ХарактеристикаНоменклатуры);

					ИначеЕсли ИмяКолонки = "ЕдиницаИзмерения" Тогда
						НоваяСтрока.Установить(Индекс, СтрокаКомплектующая.ЕдиницаИзмерения);

					ИначеЕсли ИмяКолонки = "Комплект" Тогда
						НоваяСтрока.Установить(Индекс, Ложь);

					ИначеЕсли ИмяКолонки = "Количество" Тогда
						НоваяСтрока.Установить(Индекс, СтрокаКомплект.Количество * СтрокаКомплектующая.КоличествоХранения);

					ИначеЕсли ИмяКолонки = "КоличествоДок" Тогда
						НоваяСтрока.Установить(Индекс, СтрокаКомплект.КоличествоДок * СтрокаКомплектующая.Количество);

					ИначеЕсли ИмяКолонки = "МинусКоличество" Тогда
						НоваяСтрока.Установить(Индекс, - (СтрокаКомплект.КоличествоДок * СтрокаКомплектующая.Количество));

					ИначеЕсли ИмяКолонки = "МинусСебестоимость" И ЕстьСебестоимость Тогда
						Себестоимость= ОбщегоНазначения.ПересчитатьИзВалютыВВалюту(СтрокаКомплектующая.Себестоимость,
						               СтруктураШапкиДокумента.ВалютаДокумента,
						               СтруктураШапкиДокумента.ВалютаУправленческогоУчета,
						               СтруктураШапкиДокумента.КурсДокумента,
						               СтруктураШапкиДокумента.КурсВалютыУправленческогоУчета,
						               СтруктураШапкиДокумента.КратностьДокумента,
						               СтруктураШапкиДокумента.КратностьВалютыУправленческогоУчета);
						НоваяСтрока.Установить(Индекс, - (Себестоимость * СтрокаКомплект.КоличествоДок * СтрокаКомплектующая.Количество));

					ИначеЕсли ИмяКолонки = "НоменклатураКомплекта" Тогда
						НоваяСтрока.НоменклатураКомплекта = СтрокаКомплект.Номенклатура;
					ИначеЕсли ИмяКолонки = "ХарактеристикаКомплекта" Тогда
						НоваяСтрока.ХарактеристикаКомплекта = СтрокаКомплект.ХарактеристикаНоменклатуры;
					ИначеЕсли ИмяКолонки = "КоличествоКомплекта" Тогда
						НоваяСтрока.КоличествоКомплекта = КоличествоКомплекта;
						КоличествоКомплекта = 0;
					Иначе 
						НовоеЗначение = СтрокаКомплект.Получить(Индекс);
						Если (ТипЗнч(НовоеЗначение) = Тип("Число")) Тогда
							РапределеноПоказателя = 0;
							КолекцияРаспределяемыхПоказателей.Свойство(ИмяКолонки, РапределеноПоказателя);
							РапределеноПоказателя = ?(НЕ ЗначениеЗаполнено(РапределеноПоказателя), 0, РапределеноПоказателя);
							НовоеЗначение = ?((БазаЦены - РапределеноЦены) = 0, 0, (НовоеЗначение - РапределеноПоказателя) * СтрокаКомплектующая.Цена / (БазаЦены - РапределеноЦены));
							КолекцияРаспределяемыхПоказателей.Вставить(ИмяКолонки, НовоеЗначение + РапределеноПоказателя);
						Конецесли;
						НоваяСтрока.Установить(Индекс, НовоеЗначение);
					КонецЕсли;					
				КонецЦикла;
				Если ЕстьНомерСтрокиТабличнойЧасти Тогда
					НоваяСтрока.НомерСтрокиТабличнойЧасти=СтрокаКомплектующая.НомерСтрокиТабличнойЧасти;
				КонецЕсли;
				Если ЕстьВидТабличнойЧасти Тогда
					НоваяСтрока.ВидТабличнойЧасти="СоставНабора";
				КонецЕсли;				
				РапределеноЦены = СтрокаКомплектующая.Цена + РапределеноЦены;
			КонецЦикла;
			ТаблицаРезультат.Удалить(СтрокаКомплект);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТаблицаРезультат;
КонецФункции
