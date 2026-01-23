import React, { useEffect, useState } from 'react'
import CountUp from './CountUp'

function ScoreGauge({ score, category }) {
    const [percent, setPercent] = useState(0)

    // 300 to 850 range
    // Total range = 550 points
    const percentage = Math.max(0, Math.min(100, ((score - 300) / 550) * 100))

    useEffect(() => {
        // Delay slightly to allow enter animation to finish
        const timer = setTimeout(() => {
            setPercent(percentage)
        }, 500)
        return () => clearTimeout(timer)
    }, [percentage])

    const getScoreColor = (score) => {
        if (score >= 800) return '#16a34a' // Excellent
        if (score >= 740) return '#84cc16' // Very Good
        if (score >= 670) return '#eab308' // Good
        if (score >= 580) return '#f97316' // Fair
        return '#ef4444' // Poor
    }

    const color = getScoreColor(score)

    // SVG Arc calculations
    const radius = 80
    const stroke = 12
    const normalizedRadius = radius - stroke * 2
    const circumference = normalizedRadius * 2 * Math.PI
    // Use semi-circle (divide by 2)
    const arcLength = circumference / 2
    const strokeDashoffset = arcLength - (percent / 100) * arcLength

    return (
        <div className="relative flex flex-col items-center justify-center">
            <svg
                height={radius * 2}
                width={radius * 2}
                className="transform -rotate-90 overflow-visible"
                style={{ marginBottom: -radius }} // Cut off bottom half space
            >
                {/* Track */}
                <circle
                    stroke="#e2e8f0"
                    strokeWidth={stroke}
                    fill="transparent"
                    r={normalizedRadius}
                    cx={radius}
                    cy={radius}
                    style={{
                        strokeDasharray: `${arcLength} ${circumference}`,
                        strokeLinecap: 'round'
                    }}
                    className="transition-all duration-1000 ease-out"
                />
                {/* Progress */}
                <circle
                    stroke={color}
                    strokeWidth={stroke}
                    fill="transparent"
                    r={normalizedRadius}
                    cx={radius}
                    cy={radius}
                    style={{
                        strokeDasharray: `${arcLength} ${circumference}`,
                        strokeDashoffset: strokeDashoffset,
                        strokeLinecap: 'round'
                    }}
                    className="transition-all duration-1500 ease-out"
                />

                {/* Needle/Indicator (Optional decoration) */}
            </svg>

            {/* Center Text */}
            <div className="absolute top-[40%] text-center transform -translate-y-1/2 mt-4">
                <div className="text-4xl font-bold text-slate-800 tracking-tight">
                    <CountUp end={score} />
                </div>
                <div
                    className="text-sm font-semibold uppercase tracking-wider mt-1"
                    style={{ color: color }}
                >
                    {category || 'Score'}
                </div>
            </div>

            {/* Min/Max Labels */}
            <div className="w-full flex justify-between px-8 text-xs text-slate-400 font-medium translate-y-[-20px]">
                <span>300</span>
                <span>850</span>
            </div>
        </div>
    )
}

export default ScoreGauge
