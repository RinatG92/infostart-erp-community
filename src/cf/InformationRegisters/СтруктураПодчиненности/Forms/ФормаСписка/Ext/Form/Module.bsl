﻿&НаКлиенте
Процедура ЗаполнитьПоУмолчанию(Команда)
	Элементы.Индикатор.Видимость=Истина; Заполнить(Команда.Имя);	
	ПодключитьОбработчикОжидания("ПроверитьВыполнениеЗаполнения", 1);
КонецПроцедуры

&НаСервере
Процедура Заполнить(стрКоманда)
	МассивПараметров=Новый Массив;
	МассивПараметров.Добавить(стрКоманда="ЗаполнитьПоУмолчаниюТЧ");
	ФоновоеЗадание=ФоновыеЗадания.Выполнить("СтруктураПодчиненностиСервер.ЗаполнитьПоУмолчанию", МассивПараметров);
	ИдентификаторЗадания=ФоновоеЗадание.УникальныйИдентификатор;
КонецПроцедуры

&НаСервере
Функция ЗаполнениеВыполнено()
	Задание=ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания); 
	Если Задание.Состояние=СостояниеФоновогоЗадания.Активно Тогда
		МассивСообщений=Задание.ПолучитьСообщенияПользователю(Истина);
		Количество=МассивСообщений.Количество();
		Если Количество > 0 Тогда
			МассивСтрок=СтрРазделить(МассивСообщений[МассивСообщений.Количество()-1].Текст, ";");
			Если МассивСтрок.Количество()=3 Тогда
				ТекущийИндекс=Число(МассивСтрок[1]);
				МаксимальныйИндекс=Число(МассивСтрок[2]);
				
				Индикатор=Цел(100/МаксимальныйИндекс*ТекущийИндекс);
				Элементы.Индикатор.Заголовок="Заполняется: "+МассивСтрок[0];
			Иначе
				Сообщить(МассивСообщений[МассивСообщений.Количество()-1].Текст);
			КонецЕсли;
		КонецЕсли;
		
		Возврат Ложь;

	ИначеЕсли Задание.Состояние=СостояниеФоновогоЗадания.Завершено Тогда
		Элементы.ДинамическийСписок.Обновить();
		Индикатор=100; Возврат Истина;
		
	ИначеЕсли Задание.Состояние=СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
		Элементы.ДинамическийСписок.Обновить();
		ТекущийИндекс=ТекущийИндекс+1;
		Если МаксимальныйИндекс >= ТекущийИндекс Тогда
			Возврат Истина;	
		КонецЕсли; 
		Возврат Ложь;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ПроверитьВыполнениеЗаполнения()
	Если ЗаполнениеВыполнено() Тогда
		ПоказатьОповещениеПользователя("Заполнение завершено!");
		ОтключитьОбработчикОжидания("ПроверитьВыполнениеЗаполнения");
		Элементы.Индикатор.Видимость=Ложь;
	КонецЕсли;
КонецПроцедуры