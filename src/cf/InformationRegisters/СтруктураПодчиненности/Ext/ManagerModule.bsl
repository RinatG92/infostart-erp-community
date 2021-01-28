﻿Функция ИсключитьРеквизит(стрИмя)
	Если Лев(стрИмя, 1)="_" Тогда Возврат Истина; КонецЕсли;
	Если стрИмя="ДополнительныеРеквизиты" Тогда Возврат Истина; КонецЕсли;
	Если НЕ Найти(стрИмя, "Субконто")=0 Тогда Возврат Истина; КонецЕсли;
	//Если стрИмя="ЗначениеСубконто1" Тогда Возврат Истина; КонецЕсли;
	//Если стрИмя="ЗначениеСубконто2" Тогда Возврат Истина; КонецЕсли;
	//Если стрИмя="ЗначениеСубконто3" Тогда Возврат Истина; КонецЕсли;
	Возврат Ложь;
КонецФункции 

Функция СформироватьЗапросПоУмолчанию(ОбъектМетаданных, ВернутьДерево=Ложь, ИспользоватьТЧ=Истина) Экспорт
	ИмяОбъектаМД=?(ОбъектМетаданных.ИмяПредопределенныхДанных="", ОбъектМетаданных.ПолноеИмя, ОбъектМетаданных.ИмяПредопределенныхДанных);
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

	ДанныеПоиска=Новый Массив;

	Если ВернутьДерево Тогда
		мдДерево=Новый ДеревоЗначений;		
		мдДерево.Колонки.Добавить("Идентификатор");
		мдДерево.Колонки.Добавить("Представление");
		мдДерево.Колонки.Добавить("Использование");
		мдДерево.Колонки.Добавить("Картинка");
		мдДерево.Колонки.Добавить("ЕстьРеквизитСумма");
		мдДерево.Колонки.Добавить("ЕстьРеквизитВалюта");		
	КонецЕсли;
	
	МассивМетаданных=Новый Массив;
	МассивМетаданных.Добавить(Метаданные.Документы);
	МассивМетаданных.Добавить(Метаданные.Задачи);
	МассивМетаданных.Добавить(Метаданные.БизнесПроцессы);

	Для каждого ОбъектМетаданых Из МассивМетаданных Цикл
		Для Каждого мдОбъект Из ОбъектМетаданых Цикл
			Если ИсключитьРеквизит(мдОбъект.Имя) Тогда Продолжить; КонецЕсли;

			Если ВернутьДерево Тогда
				Ветка1=мдДерево.Строки.Добавить();
				Ветка1.Идентификатор=мдОбъект.ПолноеИмя();
				Ветка1.Представление=мдОбъект.Представление();
				Ветка1.Использование=1;
				Ветка1.Картинка=БиблиотекаКартинок.Документ;
			КонецЕсли;
			
			ЕстьРеквизитСумма=Ложь;
			ЕстьРеквизитВалюта=Ложь;
			МассивРеквизитов=Новый Массив;
			Для Каждого мдРеквизит Из мдОбъект.Реквизиты Цикл				
				Если Лев(мдРеквизит.Имя, 1)="_" Тогда Продолжить; КонецЕсли; //***
				Если НЕ ВернутьДерево Тогда
					Если ИсключитьРеквизит(мдРеквизит.Имя) Тогда Продолжить; КонецЕсли;
				КонецЕсли;	
				
				Если мдРеквизит.Имя="СуммаДокумента" Тогда ЕстьРеквизитСумма=Истина;
				ИначеЕсли мдРеквизит.Имя="ВалютаДокумента" Тогда ЕстьРеквизитВалюта=Истина;
				ИначеЕсли НЕ мдРеквизит.Тип.Типы().Найти(ТипОбъекта)=Неопределено Тогда
					МассивРеквизитов.Добавить(мдРеквизит.Имя);
					Если ВернутьДерево Тогда
						Ветка2=Ветка1.Строки.Добавить();
						Ветка2.Идентификатор=мдРеквизит.Имя;
						Ветка2.Представление=мдРеквизит.Представление();
						Ветка2.Использование=1;
						Ветка2.Картинка=БиблиотекаКартинок.Реквизит;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Если ВернутьДерево Тогда
				Ветка1.ЕстьРеквизитСумма=ЕстьРеквизитСумма;
				Ветка1.ЕстьРеквизитВалюта=ЕстьРеквизитВалюта;
			КонецЕсли;
			
			Если НЕ МассивРеквизитов.Количество()=0 Тогда
				ДанныеПоиска.Добавить(Новый Структура("ИмяДокумента, ИмяТабличнойЧасти, ДанныеДокумента", мдОбъект.ПолноеИмя(), "", Новый Структура("ЕстьСумма, ЕстьВалюта, МассивРеквизитов", ЕстьРеквизитСумма, ЕстьРеквизитВалюта, МассивРеквизитов)));
			КонецЕсли;		
			
			//************************ Табличные части ************************
			Если ИспользоватьТЧ Тогда
				Для Каждого мдТабличнаяЧасть Из мдОбъект.ТабличныеЧасти Цикл
					Если Лев(мдТабличнаяЧасть.Имя, 1)="_" Тогда Продолжить; КонецЕсли; //***
					Если НЕ ВернутьДерево Тогда
						Если ИсключитьРеквизит(мдТабличнаяЧасть.Имя) Тогда Продолжить; КонецЕсли;
					КонецЕсли;
					
					Если ВернутьДерево Тогда
						ВеткаТЧ=Ветка1.Строки.Добавить();
						ВеткаТЧ.Идентификатор=мдТабличнаяЧасть.Имя;
						ВеткаТЧ.Представление=мдТабличнаяЧасть.Представление();
						ВеткаТЧ.Использование=1;
						ВеткаТЧ.Картинка=БиблиотекаКартинок.Таблица;
					КонецЕсли;
					
					МассивРеквизитов=Новый Массив;
					Для каждого мдРеквизит Из мдТабличнаяЧасть.Реквизиты Цикл
						Если Лев(мдРеквизит.Имя, 1)="_" Тогда Продолжить; КонецЕсли; //*****
						Если НЕ ВернутьДерево Тогда
							Если ИсключитьРеквизит(мдРеквизит.Имя) Тогда Продолжить; КонецЕсли;
						КонецЕсли;
						
						Если НЕ мдРеквизит.Тип.Типы().Найти(ТипОбъекта)=Неопределено Тогда
							МассивРеквизитов.Добавить(мдРеквизит.Имя);
							Если ВернутьДерево Тогда
								Ветка3=ВеткаТЧ.Строки.Добавить();
								Ветка3.Идентификатор=мдРеквизит.Имя;
								Ветка3.Представление=мдРеквизит.Представление();
								Ветка3.Использование=1;
								Ветка3.Картинка=БиблиотекаКартинок.Реквизит;
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;
					
					Если ВернутьДерево Тогда
						Если ВеткаТЧ.Строки.Количество()=0 Тогда
							Ветка1.Строки.Удалить(ВеткаТЧ);
						КонецЕсли;
					КонецЕсли;
					
					Если НЕ МассивРеквизитов.Количество()=0 Тогда
						ДанныеПоиска.Добавить(Новый Структура("ИмяДокумента, ИмяТабличнойЧасти, ДанныеДокумента", мдОбъект.ПолноеИмя(), мдТабличнаяЧасть.Имя, Новый Структура("ЕстьСумма, ЕстьВалюта, МассивРеквизитов", ЕстьРеквизитСумма, ЕстьРеквизитВалюта, МассивРеквизитов)));
					КонецЕсли;			
				КонецЦикла;
			КонецЕсли;
			//*****************************************************************
			
			Если ВернутьДерево Тогда
				Если Ветка1.Строки.Количество()=0 Тогда
					мдДерево.Строки.Удалить(Ветка1);
				КонецЕсли;
			КонецЕсли;		
		КонецЦикла;
	КонецЦикла;
	
	ТекстЗапроса="";
	Для Каждого ЭлементКоллекции Из ДанныеПоиска Цикл
		Для Каждого ИмяРеквизита Из ЭлементКоллекции.ДанныеДокумента.МассивРеквизитов Цикл
			Если НЕ ТекстЗапроса="" Тогда
				ТекстЗапроса=ТекстЗапроса+"
				|ОБЪЕДИНИТЬ ВСЕ
				|";
			КонецЕсли;

			ТекстЗапроса=ТекстЗапроса+"
			|ВЫБРАТЬ "+?(ПустаяСтрока(ТекстЗапроса), "РАЗРЕШЕННЫЕ", "")+"
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

	Возврат ?(ВернутьДерево, мдДерево, ТекстЗапроса);
КонецФункции

Функция СформироватьЗапросПоУмолчанию_Родитель(ОбъектМетаданных, ИспользоватьТЧ=Истина) Экспорт
	ДанныеПоиска=Новый Массив;

	мдОбъект=Метаданные.Документы[стрЗаменить(ОбъектМетаданных.ПолноеИмя, "Документ.", "")];

	МассивРеквизитов=Новый Массив;
	Для Каждого мдРеквизит Из мдОбъект.Реквизиты Цикл
		Если ИсключитьРеквизит(мдРеквизит.Имя) Тогда Продолжить; КонецЕсли; 
		Для каждого Тип Из мдРеквизит.Тип.Типы() Цикл
			Если Документы.ТипВсеСсылки().СодержитТип(Тип) Тогда
				МассивРеквизитов.Добавить(мдРеквизит.Имя);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если НЕ МассивРеквизитов.Количество()=0 Тогда
		ДанныеПоиска.Добавить(Новый Структура("ИмяДокумента, ИмяТабличнойЧасти, ДанныеДокумента", мдОбъект.ПолноеИмя(), "", Новый Структура("МассивРеквизитов", МассивРеквизитов)));
	КонецЕсли;		
	
	//************************ Табличные части ************************
	Если ИспользоватьТЧ Тогда
		Для Каждого мдТабличнаяЧасть Из мдОбъект.ТабличныеЧасти Цикл
			Если ИсключитьРеквизит(мдТабличнаяЧасть.Имя) Тогда Продолжить; КонецЕсли; 

			МассивРеквизитов=Новый Массив;
			Для каждого мдРеквизит Из мдТабличнаяЧасть.Реквизиты Цикл
				Если ИсключитьРеквизит(мдРеквизит.Имя) Тогда Продолжить; КонецЕсли; 
				Для каждого Тип Из мдРеквизит.Тип.Типы() Цикл
					Если Документы.ТипВсеСсылки().СодержитТип(Тип) Тогда
						МассивРеквизитов.Добавить(мдРеквизит.Имя);
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
			
			Если НЕ МассивРеквизитов.Количество()=0 Тогда
				ДанныеПоиска.Добавить(Новый Структура("ИмяДокумента, ИмяТабличнойЧасти, ДанныеДокумента", мдОбъект.ПолноеИмя(), мдТабличнаяЧасть.Имя, Новый Структура("МассивРеквизитов", МассивРеквизитов)));
			КонецЕсли;			
		КонецЦикла;
	КонецЕсли;
	//*****************************************************************
	
	ТекстЗапроса="";
	Для Каждого ЭлементКоллекции Из ДанныеПоиска Цикл
		Для Каждого ИмяРеквизита Из ЭлементКоллекции.ДанныеДокумента.МассивРеквизитов Цикл
			Если НЕ ТекстЗапроса="" Тогда
				ТекстЗапроса=ТекстЗапроса+"
				|ОБЪЕДИНИТЬ ВСЕ
				|";
			КонецЕсли;
			ТекстЗапроса=ТекстЗапроса+"
			|ВЫБРАТЬ "+?(ПустаяСтрока(ТекстЗапроса), "РАЗРЕШЕННЫЕ", "")+"
			|	ИсточникДанных."+ИмяРеквизита+" КАК Ссылка,
			|	ИсточникДанных."+ИмяРеквизита+".Дата КАК Дата,
			|	ИсточникДанных."+ИмяРеквизита+".ПометкаУдаления КАК ПометкаУдаления,
			|	"+?(Найти(ЭлементКоллекции.ИмяДокумента, "Документ.")=0, "Ложь", "ИсточникДанных."+ИмяРеквизита+".Проведен")+" КАК Проведен
			|ИЗ
			|	"+ЭлементКоллекции.ИмяДокумента+?(ЭлементКоллекции.ИмяТабличнойЧасти="", "", ".")+ЭлементКоллекции.ИмяТабличнойЧасти+" КАК ИсточникДанных
			|ГДЕ
			|	ИсточникДанных.Ссылка = &Ссылка
			|";
		КонецЦикла;
	КонецЦикла;

	Возврат ТекстЗапроса;
КонецФункции

Функция ДанныеДокумента(СсылкаНаОбъекта)
	СтруктураДанных=Новый Структура("НомерКартинки,Обработан,Ссылка,Дата,Сумма,Валюта", 0, Истина, СсылкаНаОбъекта);	
	мдОбъект=СсылкаНаОбъекта.Метаданные(); стрПолноеИмя=мдОбъект.ПолноеИмя();
	
	Запрос=Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъекта);
	Запрос.Текст="
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	"+?(Найти(стрПолноеИмя, "Документ.")=0, "Неопределено", "ИсточникДанных.Дата")+" КАК Дата,
	|	ИсточникДанных.ПометкаУдаления КАК ПометкаУдаления,
	|	"+?(Найти(стрПолноеИмя, "Документ.")=0, "Ложь", "ИсточникДанных.Проведен")+" КАК Проведен,
	|	"+?(мдОбъект.Реквизиты.Найти("СуммаДокумента")=Неопределено, 0, "ИсточникДанных.СуммаДокумента")+" КАК Сумма, 
	|	"+?(мдОбъект.Реквизиты.Найти("ВалютаДокумента")=Неопределено, 0, "ИсточникДанных.ВалютаДокумента")+" КАК Валюта
	|ИЗ
	|	"+стрПолноеИмя+" КАК ИсточникДанных
	|Где
	|	ИсточникДанных.Ссылка = &Ссылка
	|";
	Выборка=Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураДанных, Выборка);
		Если Выборка.Проведен Тогда
			СтруктураДанных.НомерКартинки=1;
		ИначеЕсли Выборка.ПометкаУдаления Тогда
			СтруктураДанных.НомерКартинки=2;
		КонецЕсли;
	КонецЕсли;

	Возврат СтруктураДанных;
КонецФункции
 
Функция ПодчиненныеДокументы(ДокументСсылка, Родители=Ложь)
	МенеджерЗаписи=РегистрыСведений.СтруктураПодчиненности.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Документ=УправлениеКонфигурациейСервер.ИдентификаторОбъектовМетаданныхСсылка(ДокументСсылка.Метаданные().ПолноеИмя());
	МенеджерЗаписи.Прочитать();
	Если НЕ МенеджерЗаписи.Выбран() Тогда Возврат Новый Массив; КонецЕсли;

	Запрос=Новый Запрос;
	Запрос.Текст=?(Родители, МенеджерЗаписи.ЗапросРодители, МенеджерЗаписи.Запрос);
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Если ПустаяСтрока(Запрос.Текст) Тогда
		Возврат Новый ТаблицаЗначений;
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Таблица родителей документов
 
Процедура тзРодители_Заполнить(тзРодители, Документ, ОбработанныеДокументы)
	тзДанные=ПодчиненныеДокументы(Документ, Истина);
	Для каждого СтрокаКоллекции Из тзДанные  Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаКоллекции.Ссылка) Тогда Продолжить; КонецЕсли;
		Если НЕ тзРодители.Найти(СтрокаКоллекции.Ссылка, "Ссылка")=Неопределено Тогда Продолжить; КонецЕсли;
		ЗаполнитьЗначенияСвойств(тзРодители.Добавить(), СтрокаКоллекции);
	КонецЦикла; 
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Дерево документов

Процедура тзДеревоДокументов_Заполнить(ВеткаДерева, Документ, ОбработанныеДокументы)
	тзДокументы=ПодчиненныеДокументы(Документ);
	Если тзДокументы.Количество()=0 Тогда Возврат; КонецЕсли;

	Для Каждого СтрокаКоллекции Из тзДокументы Цикл
		ПодчиненныйДокумент=СтрокаКоллекции.Ссылка;
		Если ОбработанныеДокументы[ПодчиненныйДокумент]=Неопределено Тогда
			РезультатПоиска=ВеткаДерева.Строки.Добавить();
			//*** ЗаполнитьЗначенияСвойств(РезультатПоиска, ДанныеДокумента(ПодчиненныйДокумент));
			ЗаполнитьЗначенияСвойств(РезультатПоиска, СтрокаКоллекции);

			Если СтрокаКоллекции.Проведен Тогда
				РезультатПоиска.НомерКартинки=1;
			ИначеЕсли СтрокаКоллекции.ПометкаУдаления Тогда
				РезультатПоиска.НомерКартинки=2;
			КонецЕсли; //1.07.2019

			ОбработанныеДокументы[ПодчиненныйДокумент]=РезультатПоиска;
			РезультатПоиска.Тип=УправлениеКонфигурациейСервер.ИдентификаторОбъектовМетаданныхСсылка(ПодчиненныйДокумент.Метаданные().ПолноеИмя());
			тзДеревоДокументов_Заполнить(РезультатПоиска, ПодчиненныйДокумент, ОбработанныеДокументы);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция тзДеревоДокументов_Сформировать(ДокументСсылка) Экспорт
	ОбработанныеДокументы=Новый Соответствие;

	тзДерево=Новый ДеревоЗначений;
	тзДерево.Колонки.Добавить("НомерКартинки", Новый ОписаниеТипов("Число"));
	тзДерево.Колонки.Добавить("Ссылка");
	тзДерево.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число"));
	тзДерево.Колонки.Добавить("Валюта", Новый ОписаниеТипов("СправочникСсылка.Валюты"));
	тзДерево.Колонки.Добавить("Основной", Новый ОписаниеТипов("Булево"));
	тзДерево.Колонки.Добавить("Тип", Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));

	тзРодители=Новый ТаблицаЗначений;
	тзРодители.Колонки.Добавить("НомерКартинки", Новый ОписаниеТипов("Число"));
	тзРодители.Колонки.Добавить("Ссылка");
	тзРодители.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число"));
	тзРодители.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	тзРодители.Колонки.Добавить("Валюта", Новый ОписаниеТипов("СправочникСсылка.Валюты"));

	тзРодители_Заполнить(тзРодители, ДокументСсылка, ОбработанныеДокументы);
	
	Если тзРодители.Количество()=0 Тогда		
		ЗаполнитьЗначенияСвойств(тзРодители.Добавить(), ДанныеДокумента(ДокументСсылка));
	Иначе
		СтрокаДокументаИсточника=тзРодители.Найти(ДокументСсылка, "Ссылка");
		Если НЕ СтрокаДокументаИсточника=Неопределено Тогда
			тзРодители.Удалить(СтрокаДокументаИсточника);
		КонецЕсли;
	КонецЕсли;
	тзРодители.Сортировать("Дата Возр");
	Для каждого СтрокаКоллекции Из тзРодители Цикл
		Документ=СтрокаКоллекции.Ссылка;
		Если НЕ ЗначениеЗаполнено(Документ) Тогда Продолжить; КонецЕсли; 
		Если НЕ ОбработанныеДокументы[Документ]=Неопределено Тогда Продолжить; КонецЕсли;
		ВеткаДерева=тзДерево.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(ВеткаДерева, ДанныеДокумента(Документ));		
		ВеткаДерева.Тип=УправлениеКонфигурациейСервер.ИдентификаторОбъектовМетаданныхСсылка(Документ.Метаданные().ПолноеИмя()); //***
		ОбработанныеДокументы[Документ]=ВеткаДерева;
		тзДеревоДокументов_Заполнить(ВеткаДерева, Документ, ОбработанныеДокументы);
	КонецЦикла;

	Возврат тзДерево;
КонецФункции