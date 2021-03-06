﻿&НаКлиенте
Процедура ВыполнитьКоманду(Команда)
	Если Команда.Имя="ОК" Тогда
		Если НЕ ЗначениеЗаполнено(ДокументСсылка) Тогда
			ПоказатьПредупреждение(, "Не заполнено поле <Документ>", 30, "Внимание");
			Возврат;
		КонецЕсли;
		СтруктураВозврата=Новый Структура;
		СтруктураВозврата.Вставить("ВариантЗаполнения", ВариантЗаполнения);
		СтруктураВозврата.Вставить("ДокументСсылка", ДокументСсылка);
		СтруктураВозврата.Вставить("ОчиститьТабличнуюЧастьПередЗаполнением", ОчиститьТабличнуюЧастьПередЗаполнением);
		ЭтаФорма.Закрыть(СтруктураВозврата);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий атрибутов шапки

&НаКлиенте
Процедура Атриубут_ПриИзменении(Элемент)
	Если Элемент.Имя="ВариантЗаполнения" Тогда
		Если ВариантЗаполнения="ЗаполнитьПоЗаказуПокупателя" Тогда
			ДокументСсылка=ПредопределенноеЗначение("Документ.ЗаказПокупателя.ПустаяСсылка");

		ИначеЕсли ВариантЗаполнения="ЗаполнитьПоВнутреннемуЗаказу" Тогда
			ДокументСсылка=ПредопределенноеЗначение("Документ.ВнутреннийЗаказ.ПустаяСсылка");

		ИначеЕсли ВариантЗаполнения="ЗаполнитьПоПотребностям" Тогда
			ДокументСсылка=Неопределено;
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ВариантЗаполнения="ЗаполнитьПоЗаказуПокупателя";
	ДокументСсылка=ПредопределенноеЗначение("Документ.ЗаказПокупателя.ПустаяСсылка");
КонецПроцедуры