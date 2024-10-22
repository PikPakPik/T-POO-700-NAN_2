import dayjs from "dayjs";

export function calculateWorkingHours(startDate: string, endDate: string): { dayHoursPerDate: Record<string, number>, nightHoursPerDate: Record<string, number> } {
    const start = dayjs(startDate);
    const end = dayjs(endDate);

    let dayHoursPerDate: Record<string, number> = {};
    let nightHoursPerDate: Record<string, number> = {};

    let current = start;
    while (current.isBefore(end)) {
        const currentDateStr = current.format('YYYY-MM-DD');

        if (!dayHoursPerDate[currentDateStr]) {
            dayHoursPerDate[currentDateStr] = 0;
            nightHoursPerDate[currentDateStr] = 0;
        }

        // Détermination du prochain changement de jour
        const nextDay = current.endOf('day').add(1, 'second');
        const intervalEnd = nextDay.isAfter(end) ? end : nextDay;
        const durationInHours = intervalEnd.diff(current, 'minutes') / 60;

        // Gestion des heures de jour/nuit par tranche horaire
        const startHour = current.hour();
        for (let hour = startHour; hour < startHour + durationInHours; hour++) {
            const realHour = hour % 24;
            const isNightHour = (realHour >= 21 || realHour < 6);
            const remainingDuration = Math.min(1, durationInHours - (hour - startHour));

            if (isNightHour) {
                nightHoursPerDate[currentDateStr] += remainingDuration;
            } else {
                dayHoursPerDate[currentDateStr] += remainingDuration;
            }
        }

        current = intervalEnd;
    }

    return { dayHoursPerDate, nightHoursPerDate };
}