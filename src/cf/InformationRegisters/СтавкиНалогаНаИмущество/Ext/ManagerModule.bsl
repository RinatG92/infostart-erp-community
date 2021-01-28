﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает налоговую ставку по умолчанию
//
// Возвращаемое значение:
//  Число - ставка налога в %
//
Функция НалоговаяСтавкаПоУмолчанию() Экспорт
	
	Возврат 2.2;
	
КонецФункции

// Возвращает налоговую ставку по умолчанию
//
// Возвращаемое значение:
//  Число - ставка налога в %
//
Функция НалоговаяСтавкаДвижимоеИмуществоПоУмолчанию() Экспорт
	
	Возврат 1.1;
	
КонецФункции

Процедура УстановитьЗначениеПоУмолчанию(Запись, ДанныеЗаполнения, ИмяРесурса, ЗначениеПоУмолчанию) Экспорт
	
	Если Не ДанныеЗаполнения.Свойство(ИмяРесурса, Запись[ИмяРесурса]) Тогда
		Запись[ИмяРесурса] = ЗначениеПоУмолчанию;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановкаНастроекПоУмолчанию(Запись, ДанныеЗаполнения) Экспорт
	
	УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"Период",
		НачалоГода(ТекущаяДатаСеанса()));
	
	УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"Организация",
		УправлениеПользователямиСервер.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация"));
	
	УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"НалоговаяСтавка",
		НалоговаяСтавкаПоУмолчанию());
		
	УстановитьЗначениеПоУмолчанию(
		Запись,
		ДанныеЗаполнения,
		"НалоговаяСтавкаДвижимоеИмущество",
		НалоговаяСтавкаДвижимоеИмуществоПоУмолчанию());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОбновитьЗаписиСтавкаНалогаДвижимогоИмуществаС2018() Экспорт
	
	НаборЗаписей = РегистрыСведений.СтавкиНалогаНаИмущество.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	
	ЗаписиКУдалению = Новый Массив;
	Для Каждого Запись Из НаборЗаписей Цикл
		Если Не ЗначениеЗаполнено(Запись.Организация) Тогда
			ЗаписиКУдалению.Добавить(Запись);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого УдаляемаяЗапись Из ЗаписиКУдалению Цикл
		НаборЗаписей.Удалить(УдаляемаяЗапись);
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НаборЗаписей[0].НалоговаяСтавкаДвижимоеИмущество) Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей.ДополнительныеСвойства.Вставить("ПропуститьПроверкуЗапретаИзменения");
	КоличествоЗаписей = НаборЗаписей.Количество();
	
	ИндексМаксимальнойЗаписиДо2018 = Новый Соответствие;
	Для Сч = 0 По КоличествоЗаписей - 1 Цикл
		
		Запись = НаборЗаписей[Сч];
		
		Если Не ЗначениеЗаполнено(Запись.НалоговаяСтавка) Тогда
			Запись.НалоговаяСтавка = НалоговаяСтавкаПоУмолчанию();
		КонецЕсли;
		
		Если Запись.Период < '2018-01-01' И Запись.Активность Тогда
			ИндексМаксимальнойЗаписиДо2018.Вставить(Запись.Организация, Сч);
			Запись.НалоговаяСтавкаДвижимоеИмущество = Запись.НалоговаяСтавка;
			Запись.ОсвобождениеОтНалогообложенияДвижимогоИмущества = Истина;
			
		ИначеЕсли Запись.Период >= '2018-01-01' И Запись.Активность Тогда
			ИндексМаксимальнойЗаписиДо2018.Вставить(Запись.Организация, Неопределено);
			Запись.НалоговаяСтавкаДвижимоеИмущество = НалоговаяСтавкаДвижимоеИмуществоПоУмолчанию();
			
		КонецЕсли;
		
		Если Запись.СнижениеНалоговойСтавки Тогда
			Запись.НалоговаяСтавка = Запись.УдалитьСниженнаяНалоговаяСтавка;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого КлючЗначение Из ИндексМаксимальнойЗаписиДо2018 Цикл
		Если КлючЗначение.Значение = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, НаборЗаписей[КлючЗначение.Значение]);
		НоваяЗапись.Период = '2018-01-01';
		НоваяЗапись.НалоговаяСтавкаДвижимоеИмущество = НалоговаяСтавкаДвижимоеИмуществоПоУмолчанию();
		НоваяЗапись.ОсвобождениеОтНалогообложенияДвижимогоИмущества = Ложь;
		
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПараметрыФормыВыбораДляКода(НазваниеМакета, ТекущийПериод) Экспорт
	
	КодыЛьгот = Новый ТаблицаЗначений;
	
	КодыЛьгот.Колонки.Добавить("Код");
	КодыЛьгот.Колонки.Добавить("Наименование");
	КодыЛьгот.Колонки.Добавить("КодЕдиницыИзмерения");
	
	Макет	= ПолучитьМакет(НазваниеМакета);
	
	НазваниеОбласти = "";
	СписокОбластей = Новый СписокЗначений;
	ОпределитьПараметрыСпискаКодов(Макет, ТекущийПериод, НазваниеОбласти, СписокОбластей);
	
	ТекущаяОбласть = Макет.Области.Найти("Область" + НазваниеОбласти);
	
	Если НЕ (ТекущаяОбласть = Неопределено) Тогда	
		
		Для НомерСтр = ТекущаяОбласть.Верх По ТекущаяОбласть.Низ Цикл
			
			// Перебираем строки макета.
			КодПоказателя       = СокрП(Макет.Область(НомерСтр, 1).Текст);
			Название            = СокрП(Макет.Область(НомерСтр, 2).Текст);
			КодЕдиницыИзмерения = СокрП(Макет.Область(НомерСтр, 3).Текст);
			
			Если КодПоказателя = "###" Тогда
				Прервать;
			ИначеЕсли ПустаяСтрока(КодПоказателя) Тогда
				Продолжить;
			Иначе
				НоваяСтрока = КодыЛьгот.Добавить();
				НоваяСтрока.Код                 = КодПоказателя;
				НоваяСтрока.Наименование        = Название;
				НоваяСтрока.КодЕдиницыИзмерения = КодЕдиницыИзмерения;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("СписокКодов"           , КодыЛьгот);
	Параметры.Вставить("СписокПериодовДействия", СписокОбластей);
	Параметры.Вставить("ТекущийПериод"         , НазваниеОбласти);
	
	Возврат Параметры;
	
КонецФункции

Процедура ОпределитьПараметрыСпискаКодов(Макет, ТекущийПериод, НазваниеОбласти, СписокОбластей)
	
	Области = Макет.Области;
	Если Области.Количество() = 0 Тогда
		НазваниеОбласти = "";
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекОбласть Из Области Цикл
		СписокОбластей.Добавить(Прав(ТекОбласть.Имя,4));
	КонецЦикла;
	
	ТекущаяОбласть = СписокОбластей[0].Значение;
	Для Каждого ТекОбласть Из СписокОбластей Цикл
		Если Год(ТекущийПериод) < Число(ТекОбласть.Значение) Тогда
			Прервать;
		КонецЕсли;
		
		ТекущаяОбласть = ТекОбласть.Значение;
	КонецЦикла;
	
	НазваниеОбласти = ТекущаяОбласть;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли