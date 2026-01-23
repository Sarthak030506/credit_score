import React, { useState, useEffect } from 'react'

const CountUp = ({ end, duration = 2000, suffix = '' }) => {
    const [count, setCount] = useState(0)

    useEffect(() => {
        let startTime = null
        const start = 0

        const animate = (currentTime) => {
            if (!startTime) startTime = currentTime
            const progress = Math.min((currentTime - startTime) / duration, 1)

            // Ease out cubic
            const ease = 1 - Math.pow(1 - progress, 3)

            setCount(Math.floor(start + (end - start) * ease))

            if (progress < 1) {
                requestAnimationFrame(animate)
            }
        }

        requestAnimationFrame(animate)
    }, [end, duration])

    return <span>{count}{suffix}</span>
}

export default CountUp
