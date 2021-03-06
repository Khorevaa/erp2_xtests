﻿Перем КонтекстЯдра;
Перем Ожидаем;
Перем Утверждения;
Перем ГенераторТестовыхДанных;
Перем ЗапросыИзБД;
Перем УтвержденияПроверкаТаблиц;

Перем СтруктураДанных;

#Область ЮнитТестирование

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	ГенераторТестовыхДанных = КонтекстЯдра.Плагин("СериализаторMXL");
	ЗапросыИзБД = КонтекстЯдра.Плагин("ЗапросыИзБД");
	УтвержденияПроверкаТаблиц = КонтекстЯдра.Плагин("УтвержденияПроверкаТаблиц");
	
	СтруктураДанных = ПолучитьСтруктуруДанных();
	
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	НаборТестов.Добавить("УстановитьОтметки");
КонецПроцедуры

Процедура ПередЗапускомТеста() Экспорт
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
КонецПроцедуры

Функция РазрешенСлучайныйПорядокВыполненияТестов() Экспорт
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

Процедура УстановитьОтметки() Экспорт
	
	Если СтруктураДанных.МассивМаршрутныхЛистов.Количество() = 0 Тогда
		ВызватьИсключение "Не найден маршрутный лист";
	КонецЕсли;	
	
	Для каждого МаршрутныйЛист из СтруктураДанных.МассивМаршрутныхЛистов Цикл
		УстановитьОтметкиМаршрутногоЛиста(МаршрутныйЛист);
	КонецЦикла;	
	
КонецПроцедуры	

Процедура УстановитьОтметкиМаршрутногоЛиста(МаршрутныйЛист) Экспорт
	
	ДокументОбъект = МаршрутныйЛист.ПолучитьОбъект();
	Если Ложь Тогда
		ДокументОбъект = Документы.МаршрутныйЛистПроизводства.СоздатьДокумент();
	КонецЕсли;	
	
	ДокументОбъект.Статус = Перечисления.СтатусыМаршрутныхЛистовПроизводства.Выполняется;
	ДокументОбъект.ПриИзмененииСтатуса(, '2016-01-01');
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	ДокументОбъект.Трудозатраты[0].КоличествоФакт = 0;
	ДокументОбъект.Трудозатраты[0].КоличествоОтклонение = -ДокументОбъект.Трудозатраты[0].Количество;
	
	ДокументОбъект.Статус = Перечисления.СтатусыМаршрутныхЛистовПроизводства.Выполнен;
	ДокументОбъект.ПриИзмененииСтатуса(, '2016-01-25');
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры	

Функция ПолучитьСтруктуруДанных()
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Данные");
	
	МассивЗаказов = Новый Массив;
	МассивЗаказов.Добавить(Структура.ЗаказНаПроизводство1);
	
	Структура.Вставить("МассивЗаказов", МассивЗаказов);
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("МассивЗаказов", МассивЗаказов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Ссылка
	|ИЗ
	|	Документ.МаршрутныйЛистПроизводства КАК Док
	|ГДЕ
	|	Док.Распоряжение В (&МассивЗаказов)";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Структура.Вставить("МассивМаршрутныхЛистов", Новый Массив);
	Иначе
		Структура.Вставить("МассивМаршрутныхЛистов", Результат.Выгрузить().ВыгрузитьКолонку("Ссылка"));
	КонецЕсли;	
	
	Возврат Структура;
	
КонецФункции




